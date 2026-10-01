@echo off
chcp 65001 >nul
setlocal
set GH="C:\Program Files\GitHub CLI\gh.exe"
cd /d "%~dp0"

echo ============================================
echo  flower_project 깃허브 업로드
echo ============================================
echo.

%GH% auth status >nul 2>&1
if errorlevel 1 (
  echo [1/3] 깃허브 로그인이 필요합니다.
  echo       Enter -^> 8자리 코드 복사 -^> 브라우저에서 Authorize
  echo.
  %GH% auth login --hostname github.com --git-protocol https --web
  if errorlevel 1 goto :fail
) else (
  echo [1/3] 이미 로그인되어 있습니다.
)
echo.

echo [2/3] 공개 저장소 flower_project 생성 및 푸시...
%GH% repo create flower_project --public --source=. --remote=origin --push --description "사람이 꽃보다 아름다워 - 대전대신고 x 대전맹학교 장애인식개선 학생동아리 프로젝트"
if errorlevel 1 goto :fail
echo.

echo [3/3] GitHub Pages 활성화...
for /f "delims=" %%u in ('%GH% api user --jq .login') do set USER=%%u
%GH% api -X POST "repos/%USER%/flower_project/pages" -f "source[branch]=main" -f "source[path]=/" >nul 2>&1

echo.
echo ============================================
echo  완료
echo  저장소 : https://github.com/%USER%/flower_project
echo  사이트 : https://%USER%.github.io/flower_project/
echo          (Pages 반영에 1~2분 걸립니다)
echo ============================================
echo.
pause
exit /b 0

:fail
echo.
echo *** 실패했습니다. 위 메시지를 확인해 주세요. ***
pause
exit /b 1
