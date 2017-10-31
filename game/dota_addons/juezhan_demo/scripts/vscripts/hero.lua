---
--- Created by Administrator.
--- DateTime: 2017/10/30 0030 22:00
-----
if HeroState == nil then
    --HeroState = class({})
    HeroState = {}
    HeroState.__index = HeroState
end
function HeroState:Init()
    self.heroTable = {}
end
function HeroState:InitHero(hero)
    -- 初始化伤害系数
    hero.bonus_magic_damage = 0         --额外百分比魔法伤害
    hero.bonus_physical_damage = 0      --额外无视护甲物理伤害
    hero.percent_bonus_damage = 0       --额外百分比所有伤害
    hero.const_reduce_damage = 0        --定值伤害减少
    hero.percent_reduce_damage = 0      --百分比伤害减少
    -- 初始化需要记录的数据
    hero.str_gain = 0                   --力量成长
    hero.agi_gain = 0                   --敏捷成长
    hero.int_gain = 0                   --智力成长
    hero.total_gold = 0                 --获取金钱总量
    hero.boss_damage = 0                --对Boss造成伤害总量
    hero.wave_def = 0                   --防守数量
    hero.practice_kill = 0              --练习数量
    hero.exp_rate = 1                   --经验获取率
    hero.gold_rate = 1                  --金钱获取率
    hero.reborn_time = 0                --转生次数
    hero.def_point = 0                  --防守积分
    local score = getPlayerScore(hero:GetPlayerID())
    print(score)
    hero.boss_point = score                 --Boss积分
    hero.practice_point = 0             --练习积分
    -- 戒指
    hero.ringCount = 0                  --记录戒指数量
    hero.ringList = {}                  --记录最后获得的戒指

    hero.courier = nil                  --信使
    hero.bag_item = {}                  --背包物品
    table.insert(self.heroTable,hero)
--[[    Timers:CreateTimer(function ()
        self:UpdateNetTable(hero)
        self:UpdateItemInSlot(hero)
        return 0.1
    end)]]
end