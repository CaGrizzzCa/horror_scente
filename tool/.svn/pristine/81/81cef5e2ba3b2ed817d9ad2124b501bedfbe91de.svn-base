
@echo off

FOR /F "tokens=*" %%A IN ('OpenFolderBox.exe' ) DO SET path=%%A


echo You choose %path%. Are you sure? [Y/N]
set /p answer=

echo %answer%

if "%answer%" == "y" (
	cd %path%

	FOR /D /r %%d IN (rm* zz* mg* ho* inv_*) DO  (
	   
	   MD %%d\anims
	   MD %%d\layers

	)
)

pause