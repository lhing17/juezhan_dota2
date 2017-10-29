-- 任务对话状态常数
local ACCEPT = 0
local INPROGRESS = 1
local FINISH = 2
local NOQUEST = 3
local FAIL = 4

if Quest == nil then
    Quest = {}
    Quest.__index = Quest
end
-- 初始化
function Quest:Init()
    -- print("任务系统初始化...")
    ListenToGameEvent('entity_killed', Dynamic_Wrap(Quest, 'OnUnitKilled'), self)
    self.questInfo = LoadKeyValues("scripts/kv/quest_info.kv")
end

-- 进入被访问NPC的范围
function VisitTriggerNpc(t)
    print("enter visit trigger npc")
    local npc = t.caster -- 拜访的NPC
    local caster = t.target -- 玩家的英雄
    print(npc:GetUnitName())
    print(caster:GetUnitName())
    for questName, questInfo in pairs(Quest.questInfo) do
        -- 判断是否是任务需求单位
        print(questInfo.targetName)
        if questInfo.targetName == npc:GetUnitName() then
            -- 判断已接受任务且未完成
            if caster[questName] then
                if caster[questName].completed == false then
                    caster[questName].remainCount = 1
                    caster[questName].completed = true
                    Quest:UpdateUI(caster, questName)
                end
            end
        end
    end
end



-- 触发任务
-- npc,物品,区域,时间,随机
function QuestTriggerNpc( t )
    local npc = t.caster
    local caster = t.target
    local questCount = 0
    local questFinish = 0
    for questName, questInfo in pairs(Quest.questInfo) do
        -- 判断npc名字得到任务
        if questInfo.triggerName == npc:GetUnitName() then
            questCount = questCount + 1
            -- 是否已接受或完成任务
            if caster[questName] == nil or (caster[questName].repeatable == "true" and caster[questName].getReward) then
                -- 判断前置条件
                local checkResult, showDialog = Quest:FrontRequireCheck(caster, questName, questInfo)
                if checkResult then
                    -- 满足前置条件
                    Quest:AddQuest(caster, npc, questName, questInfo)
                    Quest:ShowDialog(caster, npc, questName, ACCEPT)
                    break
                elseif showDialog then
                    -- 不满足前置条件
                    Quest:ShowDialog(caster, npc, questName, FAIL)
                end
            else
                if caster[questName].completed == false then
                    Quest:ShowDialog(caster, npc, questName, INPROGRESS)
                    break
                elseif caster[questName].getReward == false then
                    Quest:Finish(caster, questName)
                    Quest:ShowDialog(caster, npc, questName, FINISH)
                    break
                elseif caster[questName].getReward == true then
                    questFinish = questFinish + 1
                end
            end
        end
    end
    if questCount == questFinish then
        Quest:ShowDialog(caster, npc, "", NOQUEST)
    end
end
-- 前置条件检测
-- 等级,任务,其他
function Quest:FrontRequireCheck(caster, questName, questInfo)
    if questInfo.frontRequireType == "" then
        return true
    elseif questInfo.frontRequireType == "quest" then
        -- 是否已经完成前置任务并获得奖励
        if caster[questInfo.frontRequire] then
            if caster[questInfo.frontRequire].getReward then
                return true
            end
        end
    elseif questInfo.frontRequireType == "level" then
        if caster:GetLevel() >= questInfo.frontRequire then
            return true
        else
            return false, true
        end
    end
    return false
end
-- 接受任务
-- 将任务信息绑定在单位身上，并标记为未完成
function Quest:AddQuest(caster, npc, questName, questInfo)
    if type(questInfo.targetName) == "table" then
        for k, v in pairs(questInfo.targetName) do
            questInfo["remainCount" .. v] = 0
        end
    else
        questInfo["remainCount"] = 0
    end
    if questInfo.targetName == "random" then
        questInfo.randomTargetName = "npc_creep_sep_shiebushe" -- FIXME 随机的目标
    end
    questInfo["getReward"] = false
    questInfo["completed"] = false
    questInfo["npc"] = npc
    caster[questName] = questInfo
    self:CreateUI(caster, questName)
end
-- 任务完成过程检测
-- 击杀，收集
function Quest:OnUnitKilled(t)
    local victim = EntIndexToHScript(t.entindex_killed)
    local killer = EntIndexToHScript(t.entindex_attacker)
    if killer:IsIllusion() then
        -- 是否镜像
        if killer.caster_hero then
            killer = killer.caster_hero
        end
    end
    if victim then
        for questName, questInfo in pairs(self.questInfo) do
            -- 判断是否是任务需求单位
            if type(questInfo.targetName) == "table" then
                for _, v in pairs(questInfo.targetName) do
                    if v == victim:GetUnitName() then
                        -- 判断已接受任务且未完成
                        if killer[questName] then
                            if killer[questName].completed == false then
                                self:DeCount(killer, questName, victim)
                            end
                        end
                    end
                end
            else
                if questInfo.targetName == victim:GetUnitName() then
                    -- 判断已接受任务且未完成
                    if killer[questName] then
                        if killer[questName].completed == false then
                            self:DeCount(killer, questName, victim)
                        end
                    end
                elseif questInfo.targetName == "random" and questInfo.randomTargetName == victim:GetUnitName() then
                    -- 随机目标
                    if killer[questName] then
                        if killer[questName].completed == false then
                            self:DeCount(killer, questName, victim)
                        end
                    end
                end
            end
        end
    end
end
function Quest:Finish(caster, questName)
    if caster[questName].rewardType == "item" then
        local newItem = CreateItem(caster[questName].rewardContent, caster, caster)
        caster:AddItem(newItem)
        self:DestoryUI(caster, questName)
        caster[questName].getReward = true
    end
end

-------------------------
-- 减少需击杀怪的数量
-------------------------
function Quest:DeCount(killer, questName, victim)
    if type(killer[questName].targetName) == "table" then
        local remain = "remainCount" .. victim:GetUnitName()
        killer[questName][remain] = killer[questName][remain] + 1
        local completeFlag = true
        for k, v in pairs(killer[questName].targetName) do
            if killer[questName][remain] >= killer[questName].demandCount then
                killer[questName][remain] = killer[questName].demandCount
            else
                completeFlag = false
            end
        end
        if completeFlag then
            killer[questName].completed = true
        end
    else
        killer[questName].remainCount = killer[questName].remainCount + 1
        if killer[questName].remainCount >= killer[questName].demandCount then
            killer[questName].remainCount = killer[questName].demandCount
            killer[questName].completed = true
        end
    end
    self:UpdateUI(killer, questName)

end

-------------------------
-- 展示对话
-------------------------
function Quest:ShowDialog( caster, npc, questName, showType )
    local player = caster:GetPlayerOwner()
    local showerIndex = npc:GetEntityIndex()
    local showContent = questName
    if showType == ACCEPT then
        showContent = questName .. "Accept"
    elseif showType == INPROGRESS then
        showContent = questName .. "Inprogress"
    elseif showType == FINISH then
        showContent = questName .. "Finish"
    elseif showType == NOQUEST then
        showContent = questName .. "Noquest"
    elseif showType == FAIL then
        showContent = questName .. "Fail"
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "avalon_display_bubble", { unit = showerIndex, text = showContent, duration = 5 })
end

-------------------------
-- 创建任务UI
-------------------------
function Quest:CreateUI( caster, questName )
    local player = caster:GetPlayerOwner()
    local demandCount = caster[questName].demandCount
    local rewardContent = caster[questName].rewardContent
    CustomGameEventManager:Send_ServerToPlayer(player, "create_quest", { quest_name = questName, demand_count = demandCount, reward_content = rewardContent })
end

-------------------------
-- 删除任务UI
-------------------------
function Quest:DestoryUI( caster, questName )
    local player = caster:GetPlayerOwner()
    CustomGameEventManager:Send_ServerToPlayer(player, "destory_quest", { quest_name = questName })
end

-------------------------
-- 更新任务UI
-------------------------
function Quest:UpdateUI( caster, questName )
    local player = caster:GetPlayerOwner()
    local remainCount = caster[questName].remainCount
    CustomGameEventManager:Send_ServerToPlayer(player, "update_quest", { quest_name = questName, remain_count = remainCount })
end