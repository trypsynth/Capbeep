EnableExplicit

Macro TimerElapsed(_Timer): ElapsedMilliseconds() - _Timer: EndMacro
Macro TimerRestart(_Timer): _Timer = ElapsedMilliseconds(): EndMacro

Global BeepTimer
Global BeepTime = 1000
Global Hook, hWnd

; Hook callback to automatically preselect the text in an InputRequester.
Procedure HookCB(uMsg , wParam, lParam)
	Protected hEdit
	Select uMsg
		Case #HCBT_ACTIVATE
			hWnd = wparam
		Case #HCBT_CREATEWND
			If hwnd
				hEdit = FindWindowEx_(hwnd, #Null, "Edit", #Null)
				SendMessage_(hEdit,#EM_SETSEL,0,-1)
			EndIf    
	EndSelect  
	ProcedureReturn #False
EndProcedure

Procedure MakeSingleInstance(AppID$)
	Protected hMutex = OpenMutex_(#MUTEX_ALL_ACCESS, 0, AppID$ + "_IsAlreadyRunning")
	If Not hMutex
		hMutex = CreateMutex_(0, 0, AppID$ + "_IsAlreadyRunning")
	Else
		MessageRequester("Error", "Another instance of " + AppID$ + " is already running.", #PB_MessageRequester_Error)
		End
	EndIf
EndProcedure			

Procedure Configure()
	Hook = SetWindowsHookEx_( #WH_CBT, @ HookCB() , 0, GetCurrentThreadId_ ())
	Protected Time$ = InputRequester("Beep time", "Enter your desired beep time (in milliseconds)", Str(BeepTime))
	UnhookWindowsHookEx_ (Hook)
	Protected Time = Val(Time$)
	If Time > 0
		BeepTime = Time
		OpenPreferences("capbeep.ini")
		WritePreferenceInteger("BeepTime", Time)
		ClosePreferences()
	EndIf
EndProcedure

MakeSingleInstance("capbeep")
If FileSize("capbeep.ini") <= 0
	CreatePreferences("capbeep.ini")
	WritePreferenceInteger("BeepTime", 1000)
	ClosePreferences()
EndIf
OpenPreferences("capbeep.ini")
BeepTime = ReadPreferenceInteger("BeepTime", 1000)
ClosePreferences()
OpenWindow(0, 0, 0, 10, 10, "", #PB_Window_Invisible)
CreateImage (0, 50,  50, 32)
AddSysTrayIcon(0, WindowID(0), ImageID(0))
SysTrayIconToolTip(0, "Capbeep")
CreatePopupImageMenu(0, #PB_Menu_SysTrayLook)
MenuItem(0, "Configure beep time")
MenuBar()
MenuItem(1, "Exit")
SysTrayIconMenu(0, MenuID(0))
Repeat
	Define Event = WaitWindowEvent(1)
	If Event = #PB_Event_SysTray
		RemoveSysTrayIcon(0)
		End
	EndIf
	If Event = #PB_Event_Menu
		Define em = EventMenu()
		If em = 0
			Configure()
		ElseIf em = 1
			RemoveSysTrayIcon(0)
			End
		EndIf
	EndIf	
	If TimerElapsed(BeepTimer) >= BeepTime
		TimerRestart(BeepTimer)
		If GetKeyState_(#VK_CAPITAL) & $0001
			Beep_(500, 100)
		EndIf
	EndIf
Until Event = #PB_Event_CloseWindow
