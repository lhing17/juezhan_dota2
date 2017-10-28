---
--- Created by Administrator.
--- DateTime: 2017/9/1 0001 22:05
---

shaolin_weituogunfa = class({})

LinkLuaModifier("modifier_shaolin_weituogunfa", "abilities/shaolin/modifier_shaolin_weituogunfa.lua", LUA_MODIFIER_MOTION_NONE) --这一步仅仅是注册BUFF


function shaolin_weituogunfa:GetIntrinsicModifierName()
    return "modifier_shaolin_weituogunfa"
end