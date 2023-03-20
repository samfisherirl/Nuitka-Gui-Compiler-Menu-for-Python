﻿#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
global bat := A_ScriptDir "\bat.bat"
global tex := A_ScriptDir "\bat.txt"
pycon := A_ScriptDir "\icon\267_Python-512-_1_.ico"
if fileexist(A_ScriptDir "\icon\267_Python-512-_1_.ico")
  Menu Tray, Icon, %pycon%
else
  pycon:=""
FileCreateDir, %A_ScriptDir%\icon
; Generated by Auto-GUI 3.0.1
FileInstall, icon\267_Python-512-_1_.ico, icon\267_Python-512-_1_.ico
FileInstall, icon\1.png, icon\1.png

ico := A_ScriptDir "\icon\267_Python-512-_1_.ico"
bg := A_ScriptDir "\icon\1.png"
filetypes := ["--standalone", "--onefile", "--module"]

Gui Main: New, +LabelMain +hWndhWndMain
Gui Font, s9, Segoe UI

Gui Add, Edit, vMyText x24 y16 w749 h71 +Multi, Click browse to compile file

Gui Add, Edit, vTextForDropdown x32 y175 w249 h69 +Multi, % filetypes[1] . " --follow-imports"

Gui Add, Edit, vMyText2 x312 y128 w249 h139 +Multi, --windows-icon-from-ico="%ico%"

Gui Add, Link, x32 y328 w256 h30, <a href="https://nuitka.net/doc/user-manual.html#use-cases">Documentation/Guide for Nuitka</a>

Gui Add, Link, gNuitka x304 y328 w236 h30, <a href="">Install Nuitka</a>

Gui Add, Button, hWndhBtnCompile2 vBtnCompile2 gCompile x608 y318 w149 h25, Compile

Gui Add, Button, hWndhBtnBrowse vBtnBrowse gBrowse x608 y358 w148 h23, Browse
Gui Add, DropDownList, hWnddropdown vdropdown gdropdown x32 y128 w228, --standalone (exe)||--onefile (exe)|--module (pyc)

Gui Add, Picture, x600 y112 w163 h141, %bg%

Gui Show, w817 h413, Compile Python with Nuitka (Clone)
Return

Browse(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
  global
  FileSelectFile, files
  GuiControl,, MyText, %files%
}

Compile(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
  global
  GuiControlGet, TextForDropdown
  GuiControlGet, MyText2
  ico := StrSplit(MyText2, "=")
  if (ico[2] = "") {
    MyText2 := ""
  }
  splitpath, files,, dir
  FileDelete, %bat%
  FileAppend,
  (Ltrim
    cd %dir%
    python -m nuitka %TextForDropdown% %MyText2% "%files%"
    timeout /t 10
  ), %tex%
  Sleep, 50
  FileMove, %tex%, %bat%, 1
  Sleep, 120
  Run, bat.bat, %A_ScriptDir%
  sleep 5000
  FileDelete, %bat%
}

dropdown(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
  global filetypes
  GuiControlGet, dropdown
  GuiControlGet, TextForDropdown
  filetype := StrSplit(dropdown, " ")[1]
  replace := StrSplit(TextForDropdown, " ")[1]
  for i, v in filetypes
  {
    if InStr(replace, v)
    {
      filetype3 := StrReplace(TextForDropdown, v, filetype)
      filetype2 :=  v
      break
    }
  } 
GuiControl,, TextForDropdown, % filetype3
}

Nuitka(CtrlHwnd, GuiEvent, LinkIndex, HrefOrID) {
  global
  FileAppend,
  (Ltrim
    pip install nuitka
    timeout /t 2
  ), %tex%
  Sleep, 50
  FileMove, %tex%, %bat%, 1
  Sleep, 120
  Run, bat.bat, %A_ScriptDir%
  sleep 120
  FileDelete, %bat%

}

MainEscape(GuiHwnd) {
  ExitApp
}

MainClose(GuiHwnd) {
  ExitApp
}

GuiEscape:
GuiClose:
ExitApp
