@echo off

set ThisVer=BETA1.0.230408

title Among Us ModChooser version:%ThisVer%

echo ========================================================================
echo.
echo                           Among Us ModChooser
echo.
echo                     version:%ThisVer% by SHELL
echo.
echo ========================================================================

cd /d "%PROGRAMFILES(X86)%\Steam\steamapps\common"

rem HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam

:LOAD_CURRENTMOD
 if not exist "Among Us" (
  echo Among Us�t�H���_��������܂���B�I�����܂��B
  echo.
  pause
  exit /b -2
 )

 if exist "Among Us\ModChooserInfo.txt" (
  if not exist "Among Us__Vanilla" (
   echo �t�@�C���s�����G���[�̂��ߎ��s���p���ł��܂���B�I�����܂��B
   echo.
   pause
   exit /b -1
  )
  set ISMODAPPLYING=1
  goto GET_MODNAME
 ) else (
  set ISMODAPPLYING=0
  echo ���݃o�j���̏�Ԃł�
  goto LOAD_MODLIST
 )

:GET_MODNAME
 set /p CULLENT_MOD=<"Among Us\ModChooserInfo.txt"
 echo ���ݐݒ肳��Ă���Mod...%CULLENT_MOD%
 goto LOAD_MODLIST

:LOAD_MODLIST
 setlocal EnableDelayedExpansion

 set CNT=1
 for /d %%F in ("Among Us_*") do (
  if exist "%%F\ModChooserInfo.txt" (
   set /p LIST_MOD[!CNT!]=<"%%F\ModChooserInfo.txt"
   set /a CNT+=1
  )
 )

 goto MAIN

:MAIN
 title ���C�����j���[ - Among Us ModChooser version:%ThisVer%

 echo.
 echo.
 echo ���C�����j���[
 echo.
 echo 1.�N������Mod�̑I��
 echo 2.Mod�̒ǉ�
 echo 3.Mod�̍폜
 echo.
 echo 0.�I��
 echo.

 set Val=

 set /p Val=����^>

 if '%Val%'=='1' goto CHOOSE_MODS
 if '%Val%'=='2' goto ADD_MOD
 if '%Val%'=='3' goto DEL_MOD
 if '%Val%'=='0' goto :eof

 echo ��L�͈̔͂œ��͂��Ă�������

 goto MAIN

rem ============================== CHOOSE_MODS FIELD ==============================

:CHOOSE_MODS
 title �N������Mod�̑I�� - Among Us ModChooser version:%ThisVer%

 if '!CNT!'=='1' if '%ISMODAPPLYING%'=='0' (
  echo Mod��������܂���ł����B���C�����j���[�́uMod�̒ǉ��v����N��������Mod��ǉ����Ă��������B
  goto MAIN
 )

 set /a CNT-=1
 echo.
 echo.
 echo �N��������Mod��I�����Ă�������
 echo.
 for /l %%I in (1, 1, !CNT!) do (echo %%I.!LIST_MOD[%%I]!)
 echo.
 if '%ISMODAPPLYING%'=='1' (
  set /a CNUM=!CNT!+1
  echo !CNUM!.�o�j���ɖ߂�
  echo.
 )
 echo 0.�߂�
 echo.

 set Val=

 set /p Val=����^>

 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )
 if '%Val%' geq '1' if '%Val%' leq '!CNT!' (
  goto CHANGE_MODS
 )
 if '%ISMODAPPLYING%'=='1' if '%Val%'=='!CNUM!' (
  goto RESTORE_VANILLA
 )

 echo ��L�͈̔͂œ��͂��Ă�������
 set /a CNT+=1
 goto CHOOSE_MODS

:CHANGE_MODS
 if '%ISMODAPPLYING%'=='0' ren "Among Us" "Among Us__Vanilla"
 if '%ISMODAPPLYING%'=='1' ren "Among Us" "Among Us_%CULLENT_MOD%"
 ren "Among Us_!LIST_MOD[%Val%]!" "Among Us"

 echo Mod��ݒ肵�܂���
 echo.
 endlocal
 goto LOAD_CURRENTMOD

:RESTORE_VANILLA
 ren "Among Us" "Among Us_%CULLENT_MOD%"
 ren "Among Us__Vanilla" "Among Us"
 echo �o�j���ɖ߂��܂���
 echo.
 endlocal
 goto LOAD_CURRENTMOD

rem ============================== ADD_MOD FIELD ==============================

:ADD_MOD
 title Mod�̒ǉ� - Among Us ModChooser version:%ThisVer%

 echo.
 echo.
 echo ����������Mod�̃��\�[�X���܂܂�Ă���t�H���_(�W�J�������)�̃t���p�X����͂��Ă�������
 echo (�����͏�ԂŊm�肷��ƃL�����Z�����܂�)
 echo.

 set ADD_DIR=

 set /p ADD_DIR=�p�X^>

 if "%ADD_DIR%"=="" goto MAIN

 if not exist "%ADD_DIR%" (
  echo �w�肳�ꂽ�t�H���_��������܂���
  goto ADD_MOD
 )

 goto ADD_MOD_2

:ADD_MOD_2
 echo.
 echo.
 echo Mod�̖��O�𔼊p�p�����œ��͂��Ă�������
 echo (�����͏�ԂŊm�肷��ƃL�����Z�����܂�)
 echo.

 set ADD_NAME=

 set /p ADD_NAME=���O^>

 if "%ADD_NAME%"=="" goto MAIN

 set /a CNT-=1
 for /l %%I in (1, 1, !CNT!) do (
  if "%ADD_NAME%"=="!LIST_MOD[%%I]!" (
   echo ���̖��O��Mod�͊��ɑ��݂��܂�
   set /a CNT+=1
   goto ADD_MOD_2
  )
 )

 rem ���̃R�[�h�ł͌��ݐݒ肳��Ă���Mod�����o�ł��Ȃ�

 goto ADD_MOD_3

:ADD_MOD_3
 echo.
 echo.
 echo �ȉ��̏���Mod��ǉ����܂�
 echo.
 echo �p�X:%ADD_DIR%
 echo ���O:%ADD_NAME%
 echo.
 echo 1.�쐬
 echo 0.�L�����Z��
 echo.

 set Val=

 set /p Val=����^>

 if '%Val%'=='1' goto ADD_MOD_RUN
 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )


 echo ��L�͈̔͂œ��͂��Ă�������
 echo.

 goto ADD_MOD_3

:ADD_MOD_RUN
 if exist "Among Us__Vanilla" (
  set VANILLA_FOLDER="Among Us__Vanilla"
 ) else (
  set VANILLA_FOLDER="Among Us"
 )
 xcopy %VANILLA_FOLDER% "Among Us_%ADD_NAME%" /e /i
 xcopy "%ADD_DIR%" "Among Us_%ADD_NAME%" /e

 set /p<nul="%ADD_NAME%">"Among Us_%ADD_NAME%\ModChooserInfo.txt"

 echo.
 echo.
 echo Mod��ǉ����܂���

 endlocal
 goto LOAD_MODLIST

rem ============================== DEL_MOD FIELD ==============================

:DEL_MOD
 title Mod�̍폜 - Among Us ModChooser version:%ThisVer%

 if '!CNT!'=='1' if '%ISMODAPPLYING%'=='0' (
  echo �폜�ł���Mod��������܂���ł����B
  goto MAIN
 ) else if '%ISMODAPPLYING%'=='1' (
  echo �폜�ł���Mod��������܂���ł����B
  echo �����ݐݒ肳��Ă���Mod���폜����ɂ́A"���C�����j���["��"�N������Mod�̑I��"����o�j���ɖ߂��K�v������܂��B
  goto MAIN
 )

 set /a CNT-=1
 echo.
 echo.
 echo �폜������Mod��I�����Ă�������
 if '%ISMODAPPLYING%'=='1' (
  echo �����ݐݒ肳��Ă���Mod���폜����ɂ́A�u���C�����j���[�v�́u�N������Mod�̑I���v����o�j���ɖ߂��K�v������܂��B
 )
 echo.
 for /l %%I in (1, 1, !CNT!) do (echo %%I.!LIST_MOD[%%I]!)
 echo.
 echo 0.�߂�
 echo. 

 set Val=

 set /p Val=����^>

 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )
 if '%Val%' geq '1' if '%Val%' leq '!CNT!' (
  set SelectNum=%Val%
  goto DEL_MOD_CONFIRM
 )

 echo ��L�͈̔͂œ��͂��Ă�������

 set /a CNT+=1
 goto DEL_MOD

:DEL_MOD_CONFIRM
 echo.
 echo.
 echo Mod"!LIST_MOD[%SelectNum%]!"���폜���܂�
 echo �����̑���͎������܂���
 echo.
 echo 1.�폜
 echo 0.�L�����Z��
 echo.

 set Val=

 set /p Val=����^>

 if '%Val%'=='1' goto DEL_MOD_RUN
 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )

 echo ��L�͈̔͂œ��͂��Ă�������

 goto DEL_MOD_CONFIRM

:DEL_MOD_RUN
 rd /s /q "Among Us_!LIST_MOD[%SelectNum%]!"
 echo Mod���폜���܂���
 echo.
 endlocal
 goto LOAD_MODLIST