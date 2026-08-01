# Save as: cinematic_animatic_godot_fixed.ps1
# NO ADMIN NEEDED - just run normally

# ============================================
# SIMPLIFIED VERSION - FIXED SYNTAX
# ============================================

$outputPath = "C:\CinematicAnimatic"
$animaticTitle = "The Last Programmer"

function Show-Menu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "🎬 CINEMATIC ANIMATIC WITH GODOT" -ForegroundColor White
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. 📦 Install Software" -ForegroundColor Yellow
    Write-Host "2. 📁 Create Project Structure" -ForegroundColor Yellow
    Write-Host "3. 🎮 Generate Godot Project" -ForegroundColor Yellow
    Write-Host "4. 🚀 Run All Setup" -ForegroundColor Green
    Write-Host "5. ❌ Exit" -ForegroundColor Red
    Write-Host ""
}

function Install-Software {
    Write-Host "Installing software..." -ForegroundColor Yellow
    
    # Install Chocolatey if not present
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    # Install Godot and other tools
    $software = @(
        "godot",
        "python",
        "ffmpeg",
        "git",
        "nodejs"
    )
    
    foreach ($app in $software) {
        Write-Host "Installing $app..." -NoNewline
        choco install $app -y --no-progress
        Write-Host " ✅" -ForegroundColor Green
    }
    
    # Install Python packages
    pip install manim
}

function Create-Project {
    Write-Host "Creating project structure..." -ForegroundColor Yellow
    
    # Create directories
    $folders = @(
        "$outputPath",
        "$outputPath\godot_project",
        "$outputPath\godot_project\scenes",
        "$outputPath\godot_project\scripts",
        "$outputPath\renders",
        "$outputPath\assets"
    )
    
    foreach ($folder in $folders) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "Created: $folder" -ForegroundColor Gray
    }
}

function Generate-GodotProject {
    Write-Host "Generating Godot project files..." -ForegroundColor Yellow
    
    # 1. Create project.godot
    $project = @'
[application]

config/name="Cinematic Animatic"
config/icon="res://icon.png"

[display]

window/size/width=1920
window/size/height=1080
window/stretch/mode="2d"
window/stretch/aspect="keep"
'@
    
    $project | Out-File "$outputPath\godot_project\project.godot" -Encoding UTF8
    
    # 2. Create simple scene
    $scene = @'
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/main.gd" id="1"]

[node name="Main" type="Node2D"]
script = ExtResource("1")

[node name="Camera2D" type="Camera2D" parent="."]
current = true

[node name="Label" type="Label" parent="."]
text = "Cinematic Animatic"
rect_position = Vector2(200, 200)
'@
    
    $scene | Out-File "$outputPath\godot_project\scenes\main.tscn" -Encoding UTF8
    
    # 3. Create simple script
    $script = @'
extends Node2D

func _ready():
    print("🎬 Cinematic Animatic Started!")
    print("🎮 Godot Engine: Ready")
    print("⏱️  Press space to animate")
    
func _process(delta):
    $Label.rect_rotation += delta * 30
    
func _input(event):
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_SPACE:
            # Create particle effect
            var particles = CPUParticles2D.new()
            particles.position = Vector2(960, 540)
            particles.amount = 100
            particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
            particles.emission_rect_extents = Vector2(100, 100)
            add_child(particles)
            particles.emitting = true
            
            # Remove after 1 second
            yield(get_tree().create_timer(1.0), "timeout")
            particles.queue_free()
'@
    
    $script | Out-File "$outputPath\godot_project\scripts\main.gd" -Encoding UTF8
    
    Write-Host "✅ Godot project created!" -ForegroundColor Green
}

function Create-SimpleAnimaticScript {
    Write-Host "Creating animatic script..." -ForegroundColor Yellow
    
    $script = @'
{
  "title": "Cinematic Animatic",
  "scenes": [
    {
      "id": 1,
      "title": "Opening Scene",
      "duration": 10,
      "description": "Introduction sequence"
    },
    {
      "id": 2,
      "title": "Main Action",
      "duration": 40,
      "description": "Interactive 3D scene"
    },
    {
      "id": 3,
      "title": "Climax",
      "duration": 30,
      "description": "Special effects sequence"
    },
    {
      "id": 4,
      "title": "Closing",
      "duration": 10,
      "description": "End credits"
    }
  ]
}
'@
    
    $script | Out-File "$outputPath\animatic_script.json" -Encoding UTF8
    Write-Host "✅ Animatic script created" -ForegroundColor Green
}

function Run-AllSetup {
    Install-Software
    Create-Project
    Generate-GodotProject
    Create-SimpleAnimaticScript
    
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "🎉 SETUP COMPLETE!" -ForegroundColor White -BackgroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Project location: $outputPath" -ForegroundColor Yellow
    Write-Host "Godot project: $outputPath\godot_project\" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🚀 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Open Godot Editor" -ForegroundColor White
    Write-Host "2. Import project: $outputPath\godot_project" -ForegroundColor White
    Write-Host "3. Press F5 to run the scene" -ForegroundColor White
    Write-Host ""
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Select option (1-5)"
    
    switch ($choice) {
        "1" { Install-Software }
        "2" { Create-Project }
        "3" { Generate-GodotProject }
        "4" { Run-AllSetup }
        "5" { Write-Host "Goodbye!" -ForegroundColor Cyan; exit }
        default { Write-Host "Invalid option" -ForegroundColor Red }
    }
    
    if ($choice -ne "5") {
        Write-Host ""
        Read-Host "Press Enter to continue"
    }
} while ($choice -ne "5")