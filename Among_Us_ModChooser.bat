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
  echo Among Usフォルダが見つかりません。終了します。
  echo.
  pause
  exit /b -2
 )

 if exist "Among Us\ModChooserInfo.txt" (
  if not exist "Among Us__Vanilla" (
   echo ファイル不整合エラーのため実行を継続できません。終了します。
   echo.
   pause
   exit /b -1
  )
  set ISMODAPPLYING=1
  goto GET_MODNAME
 ) else (
  set ISMODAPPLYING=0
  echo 現在バニラの状態です
  goto LOAD_MODLIST
 )

:GET_MODNAME
 set /p CULLENT_MOD=<"Among Us\ModChooserInfo.txt"
 echo 現在設定されているMod...%CULLENT_MOD%
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
 title メインメニュー - Among Us ModChooser version:%ThisVer%

 echo.
 echo.
 echo メインメニュー
 echo.
 echo 1.起動するModの選択
 echo 2.Modの追加
 echo 3.Modの削除
 echo.
 echo 0.終了
 echo.

 set Val=

 set /p Val=入力^>

 if '%Val%'=='1' goto CHOOSE_MODS
 if '%Val%'=='2' goto ADD_MOD
 if '%Val%'=='3' goto DEL_MOD
 if '%Val%'=='0' goto :eof

 echo 上記の範囲で入力してください

 goto MAIN

rem ============================== CHOOSE_MODS FIELD ==============================

:CHOOSE_MODS
 title 起動するModの選択 - Among Us ModChooser version:%ThisVer%

 if '!CNT!'=='1' if '%ISMODAPPLYING%'=='0' (
  echo Modが見つかりませんでした。メインメニューの「Modの追加」から起動したいModを追加してください。
  goto MAIN
 )

 set /a CNT-=1
 echo.
 echo.
 echo 起動したいModを選択してください
 echo.
 for /l %%I in (1, 1, !CNT!) do (echo %%I.!LIST_MOD[%%I]!)
 echo.
 if '%ISMODAPPLYING%'=='1' (
  set /a CNUM=!CNT!+1
  echo !CNUM!.バニラに戻す
  echo.
 )
 echo 0.戻る
 echo.

 set Val=

 set /p Val=入力^>

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

 echo 上記の範囲で入力してください
 set /a CNT+=1
 goto CHOOSE_MODS

:CHANGE_MODS
 if '%ISMODAPPLYING%'=='0' ren "Among Us" "Among Us__Vanilla"
 if '%ISMODAPPLYING%'=='1' ren "Among Us" "Among Us_%CULLENT_MOD%"
 ren "Among Us_!LIST_MOD[%Val%]!" "Among Us"

 echo Modを設定しました
 echo.
 endlocal
 goto LOAD_CURRENTMOD

:RESTORE_VANILLA
 ren "Among Us" "Among Us_%CULLENT_MOD%"
 ren "Among Us__Vanilla" "Among Us"
 echo バニラに戻しました
 echo.
 endlocal
 goto LOAD_CURRENTMOD

rem ============================== ADD_MOD FIELD ==============================

:ADD_MOD
 title Modの追加 - Among Us ModChooser version:%ThisVer%

 echo.
 echo.
 echo 導入したいModのリソースが含まれているフォルダ(展開した状態)のフルパスを入力してください
 echo (未入力状態で確定するとキャンセルします)
 echo.

 set ADD_DIR=

 set /p ADD_DIR=パス^>

 if "%ADD_DIR%"=="" goto MAIN

 if not exist "%ADD_DIR%" (
  echo 指定されたフォルダが見つかりません
  goto ADD_MOD
 )

 goto ADD_MOD_2

:ADD_MOD_2
 echo.
 echo.
 echo Modの名前を半角英数字で入力してください
 echo (未入力状態で確定するとキャンセルします)
 echo.

 set ADD_NAME=

 set /p ADD_NAME=名前^>

 if "%ADD_NAME%"=="" goto MAIN

 set /a CNT-=1
 for /l %%I in (1, 1, !CNT!) do (
  if "%ADD_NAME%"=="!LIST_MOD[%%I]!" (
   echo その名前のModは既に存在します
   set /a CNT+=1
   goto ADD_MOD_2
  )
 )

 rem このコードでは現在設定されているModを検出できない

 goto ADD_MOD_3

:ADD_MOD_3
 echo.
 echo.
 echo 以下の情報でModを追加します
 echo.
 echo パス:%ADD_DIR%
 echo 名前:%ADD_NAME%
 echo.
 echo 1.作成
 echo 0.キャンセル
 echo.

 set Val=

 set /p Val=入力^>

 if '%Val%'=='1' goto ADD_MOD_RUN
 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )


 echo 上記の範囲で入力してください
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
 echo Modを追加しました

 endlocal
 goto LOAD_MODLIST

rem ============================== DEL_MOD FIELD ==============================

:DEL_MOD
 title Modの削除 - Among Us ModChooser version:%ThisVer%

 if '!CNT!'=='1' if '%ISMODAPPLYING%'=='0' (
  echo 削除できるModが見つかりませんでした。
  goto MAIN
 ) else if '%ISMODAPPLYING%'=='1' (
  echo 削除できるModが見つかりませんでした。
  echo ※現在設定されているModを削除するには、"メインメニュー"の"起動するModの選択"からバニラに戻す必要があります。
  goto MAIN
 )

 set /a CNT-=1
 echo.
 echo.
 echo 削除したいModを選択してください
 if '%ISMODAPPLYING%'=='1' (
  echo ※現在設定されているModを削除するには、「メインメニュー」の「起動するModの選択」からバニラに戻す必要があります。
 )
 echo.
 for /l %%I in (1, 1, !CNT!) do (echo %%I.!LIST_MOD[%%I]!)
 echo.
 echo 0.戻る
 echo. 

 set Val=

 set /p Val=入力^>

 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )
 if '%Val%' geq '1' if '%Val%' leq '!CNT!' (
  set SelectNum=%Val%
  goto DEL_MOD_CONFIRM
 )

 echo 上記の範囲で入力してください

 set /a CNT+=1
 goto DEL_MOD

:DEL_MOD_CONFIRM
 echo.
 echo.
 echo Mod"!LIST_MOD[%SelectNum%]!"を削除します
 echo ※この操作は取り消せません
 echo.
 echo 1.削除
 echo 0.キャンセル
 echo.

 set Val=

 set /p Val=入力^>

 if '%Val%'=='1' goto DEL_MOD_RUN
 if '%Val%'=='0' (
  set /a CNT+=1
  goto MAIN
 )

 echo 上記の範囲で入力してください

 goto DEL_MOD_CONFIRM

:DEL_MOD_RUN
 rd /s /q "Among Us_!LIST_MOD[%SelectNum%]!"
 echo Modを削除しました
 echo.
 endlocal
 goto LOAD_MODLIST