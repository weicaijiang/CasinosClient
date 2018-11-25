-- Copyright(c) Cragon. All rights reserved.
-- 关于对话框的设置模块

---------------------------------------
ViewEdit = ViewBase:new()

---------------------------------------
function ViewEdit:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.ViewMgr = nil
    o.GoUi = nil
    o.ComUi = nil
    o.Panel = nil
    o.UILayer = nil
    o.InitDepth = nil
    o.ViewKey = nil
    o.Tween = nil
    return o
end

---------------------------------------
function ViewEdit:OnCreate()
    self.Tween = ViewHelper:PopUi(self.ComUi, self.ViewMgr.LanMgr:getLanValue("Edit"))
    local com_bg = self.ComUi:GetChild("ComBgAndClose").asCom
    local btn_close = com_bg:GetChild("BtnClose").asButton
    btn_close.onClick:Add(
            function()
                self:onClickBtnReturn()
            end
    )
    local com_shade = com_bg:GetChild("ComShade").asCom
    com_shade.onClick:Add(
            function()
                self:onClickBtnReturn()
            end
    )
    self.BtnResetPwd = self.ComUi:GetChild("BtnResetPwd").asButton
    self.BtnResetPwd.onClick:Add(
            function()
                self:onClickResetPwd()
            end
    )

    local btn_select_lan = self.ComUi:GetChild("Lan_Btn_SelectLanguage").asButton
    btn_select_lan.onClick:Add(
            function()
                self:onClickSelectLan()
            end
    )
    self.SoundBar = self.ComUi:GetChild("soundBar").asSlider
    local volum_bg = 0.5
    if (CS.UnityEngine.PlayerPrefs.HasKey(CS.Casinos.SoundMgr.BGMusicKey)) then
        volum_bg = CS.UnityEngine.PlayerPrefs.GetFloat(CS.Casinos.SoundMgr.BGMusicKey)
    end
    self.SoundBar.value = volum_bg * 100
    self.SoundBar.onChanged:Add(
            function()
                self:sliderMusicChange()
            end
    )
    self.SoundEffectBar = self.ComUi:GetChild("soundEffectBar").asSlider
    local volum = 0.5
    if (CS.UnityEngine.PlayerPrefs.HasKey(CS.Casinos.SoundMgr.SoundKey))
    then
        volum = CS.UnityEngine.PlayerPrefs.GetFloat(CS.Casinos.SoundMgr.SoundKey)
    end
    self.SoundEffectBar.value = volum * 100
    self.SoundEffectBar.onChanged:Add(
            function()
                self:sliderSoundChange()
            end
    )
    local com_abount = self.ComUi:GetChild("ComAbount").asCom
    com_abount.onClick:Add(
            function()
                self.ViewMgr:CreateView("About")
            end
    )
    self.GBtnSwitchScreenAutoRotation = self.ComUi:GetChild("BtnSwitch").asButton
    self.GBtnSwitchScreenAutoRotation.onClick:Add(
            function()
                self:onClickBtnSwitch()
            end
    )
    if (CS.UnityEngine.PlayerPrefs.HasKey("ScreenAutoRotation"))
    then
        local autoRotation = CS.UnityEngine.PlayerPrefs.GetString("ScreenAutoRotation")
        if (autoRotation == "true")
        then
            self.GBtnSwitchScreenAutoRotation.selected = true
        else
            self.GBtnSwitchScreenAutoRotation.selected = false
        end
    end
end

---------------------------------------
function ViewEdit:OnDestroy()
    if self.Tween ~= nil then
        self.Tween:Kill(false)
        self.Tween = nil
    end
end

---------------------------------------
function ViewEdit:onClickBtnSwitch()
    local screen = CS.UnityEngine.Screen
    if (self.GBtnSwitchScreenAutoRotation.selected == true)
    then
        CS.UnityEngine.PlayerPrefs.SetString("ScreenAutoRotation", "true")
        screen.orientation = CS.UnityEngine.ScreenOrientation.AutoRotation
        screen.autorotateToLandscapeRight = true
        screen.autorotateToLandscapeLeft = true
        screen.autorotateToPortraitUpsideDown = false
        screen.autorotateToPortrait = false
    else
        CS.UnityEngine.PlayerPrefs.SetString("ScreenAutoRotation", "false")
        screen.orientation = CS.UnityEngine.ScreenOrientation.LandscapeLeft
    end

end

---------------------------------------
function ViewEdit:sliderMusicChange()
    local current_value = self.SoundBar.value
    current_value = current_value / 100
    CS.UnityEngine.PlayerPrefs.SetFloat(CS.Casinos.SoundMgr.BGMusicKey, current_value)
    CS.Casinos.CasinosContext.Instance:bgVolumeChange(current_value)
end

---------------------------------------
function ViewEdit:sliderSoundChange()
    local current_value = self.SoundEffectBar.value
    current_value = current_value / 100
    CS.UnityEngine.PlayerPrefs.SetFloat(CS.Casinos.SoundMgr.SoundKey, current_value)
end

---------------------------------------
function ViewEdit:onClickResetPwd()
    self.ViewMgr:CreateView("ResetPwd")
end

---------------------------------------
function ViewEdit:onClickSelectLan()
    self.ViewMgr:CreateView("ChooseLan")
end

---------------------------------------
function ViewEdit:onClickBtnReturn()
    self.ViewMgr:DestroyView(self)
end

---------------------------------------
ViewEditFactory = ViewFactory:new()

---------------------------------------
function ViewEditFactory:new(o, ui_package_name, ui_component_name, ui_layer, is_single, fit_screen)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.PackageName = ui_package_name
    self.ComponentName = ui_component_name
    self.UILayer = ui_layer
    self.IsSingle = is_single
    self.FitScreen = fit_screen
    return o
end

---------------------------------------
function ViewEditFactory:CreateView()
    local view = ViewEdit:new(nil)
    return view
end