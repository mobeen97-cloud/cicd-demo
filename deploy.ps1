# Deploy the published image to this laptop, then smoke-test it.
# Usage:
#   ./deploy.ps1                 # deploy the newest version (latest)
#   ./deploy.ps1 -Tag <sha>      # deploy or roll back to an exact commit
param([string]$Tag = 'latest')

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$env:TAG = $Tag

Write-Host "Pulling image tag '$Tag' from ghcr.io..."
docker compose pull
if ($LASTEXITCODE -ne 0) { throw 'docker compose pull failed' }

Write-Host 'Starting container...'
docker compose up -d
if ($LASTEXITCODE -ne 0) { throw 'docker compose up failed' }

# Smoke test: retry /health for up to 30 seconds.
for ($i = 1; $i -le 15; $i++) {
  try {
    $health = Invoke-RestMethod http://localhost:3000/health
    if ($health.status -eq 'ok') {
      $sum = (Invoke-RestMethod 'http://localhost:3000/add?a=2&b=3').result
      if ($sum -ne 5) { throw "/add returned $sum, expected 5" }
      Write-Host "Deploy OK: tag '$Tag' is healthy and /add works." -ForegroundColor Green
      exit 0
    }
  } catch { Start-Sleep 2 }
}
Write-Host 'Deploy FAILED: app did not become healthy.' -ForegroundColor Red
docker compose logs --tail 20
exit 1
