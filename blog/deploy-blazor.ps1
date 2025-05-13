$ErrorActionPreference = "Stop"

$branch = "gh-pages"
$publishDir = "bin\Release\net9.0\publish\wwwroot"
$repoUrl = git config --get remote.origin.url

Write-Host "🧱 Building Blazor WebAssembly app..."
dotnet publish -c Release

Write-Host "🚀 Preparing deployment directory..."
Set-Location $publishDir
if (-not (Test-Path ".nojekyll")) {
    New-Item -Path ".nojekyll" -ItemType File -Force | Out-Null
}

if (-not (Test-Path ".git")) {
    Write-Host "📦 Initializing Git repository..."
    git init
    git remote add origin $repoUrl
} else {
    Write-Host "🔁 Git repo already initialized."
}

# Check if branch exists locally
$branchExists = git branch --list $branch
if ($branchExists) {
    Write-Host "🔀 Switching to existing '$branch' branch..."
    git checkout $branch
} else {
    Write-Host "🆕 Creating new '$branch' branch..."
    git checkout -b $branch
}

Write-Host "📤 Staging and pushing to GitHub Pages..."
git add .

# Try to commit only if there are changes
try {
    git commit -m "Deploy Blazor WASM to GitHub Pages"
} catch {
    Write-Host "⚠️ No changes to commit."
}

git push origin $branch --force

Write-Host "✅ Deployment complete!"