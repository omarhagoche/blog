#!/bin/bash

set -e

REPO_URL=$(git config --get remote.origin.url)
BRANCH="gh-pages"
PUBLISH_DIR="bin/Release/net9.0/publish/wwwroot"

if [ ! -d "$PUBLISH_DIR" ]; then
  echo "❌ Publish directory not found: $PUBLISH_DIR"
  exit 1
fi

echo "🧱 Building Blazor WebAssembly app..."
dotnet publish -c Release

echo "🚀 Preparing deployment directory..."
cd "$PUBLISH_DIR"
touch .nojekyll

if [ ! -d ".git" ]; then
  echo "📦 Initializing Git repository..."
  git init
  git remote add origin "$REPO_URL"
else
  echo "🔁 Git repo already initialized."
fi

# Check if branch exists locally and switch to it
if git show-ref --quiet refs/heads/$BRANCH; then
  echo "🔀 Switching to existing '$BRANCH' branch..."
  git checkout $BRANCH
else
  echo "🆕 Creating new '$BRANCH' branch..."
  git checkout -b $BRANCH
fi

echo "📤 Staging and pushing to GitHub Pages..."
git add .
git commit -m "Deploy Blazor WASM to GitHub Pages" || echo "⚠️ No changes to commit"
git push origin $BRANCH --force

echo "✅ Deployment complete!"