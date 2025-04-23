/* Capbeep - simple program to beep if you type while your capslock is turned on.
 *
 * Copyright (c) 2022-2025 Quin Gillespie
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <windows.h>

HHOOK hook;

LRESULT CALLBACK keyboard_proc(int code, WPARAM wp, LPARAM lp);
DWORD WINAPI beep_function(LPVOID param);

int WINAPI WinMain(HINSTANCE instance, HINSTANCE prev_instance, PSTR cmd_line, int show) {
	hook = SetWindowsHookEx(WH_KEYBOARD_LL, keyboard_proc, NULL, 0);
	if (hook == NULL) {
		MessageBox(NULL, "Failed to install keyboard hook!", "Error", MB_ICONERROR);
		return 1;
	}
	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	UnhookWindowsHookEx(hook);
	return 0;
}

LRESULT CALLBACK keyboard_proc(int code, WPARAM wp, LPARAM lp) {
	if (code == HC_ACTION && wp == WM_KEYDOWN) {
		if (GetKeyState(VK_CAPITAL) & 0x0001) CreateThread(NULL, 0, beep_function, NULL, 0, NULL);
	}
	return CallNextHookEx(hook, code, wp, lp);
}

DWORD WINAPI beep_function(LPVOID param) {
	Beep(750, 200);
	return 0;
}
