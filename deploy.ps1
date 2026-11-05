# 일손덜기 홈페이지를 GitHub Pages로 공개하는 스크립트
# 사전 준비: Git, GitHub CLI(gh) 설치 후 `gh auth login` 한 번 실행
param([string]$Repo = "ilsondeolgi")
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
if (-not (Test-Path .git)) { git init -b main | Out-Null }
git add -A
git commit -m "일손덜기 홈페이지 배포" 2>$null
$user = gh api user --jq .login
if (-not (gh repo view "$user/$Repo" 2>$null)) {
  gh repo create "$user/$Repo" --public --source . --remote origin --push
} else {
  if (-not (git remote get-url origin 2>$null)) { git remote add origin "https://github.com/$user/$Repo.git" }
  git push -u origin main
}
gh api -X POST "repos/$user/$Repo/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null
Write-Host "공개 주소: https://$user.github.io/$Repo/"
