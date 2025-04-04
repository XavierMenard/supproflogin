# Fonction pour vérifier si le script est exécuté en tant qu'administrateur
function Run-AsAdministrator {
    if (-not [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator) {
        $arguments = "& '$($myinvocation.mycommand.definition)'"
        Start-Process powershell -ArgumentList $arguments -Verb runAs
        exit
    }
}

# Vérifier si le script est lancé en tant qu'administrateur, sinon relancer en mode admin
Run-AsAdministrator

# Charger Windows Forms pour l'interface graphique
Add-Type -AssemblyName System.Windows.Forms

# Fonction de validation du login
function Validate-Login {
    param (
        [string]$code
    )
    
    # Vérifier si le code contient exactement 7 chiffres
    if ($code.Length -eq 7 -and $code -match '^\d{7}$') {
        return $true
    }
    return $false
}

# Fonction pour créer le formulaire de login esthétique
function Show-LoginForm {
    # Création de la fenêtre de login avec une taille et une couleur de fond
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Connection Supprof"  
    $form.Size = New-Object System.Drawing.Size(350, 200)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.BackColor = [System.Drawing.Color]::FromArgb(255, 240, 240)

    # Label pour le champ de texte
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Entrez un code à 7 chiffres :"
    $label.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $label.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)  
    $label.Location = New-Object System.Drawing.Point(10, 30)
    $label.Width = 300
    $form.Controls.Add($label)

    # Champ de texte pour entrer le code avec restriction aux chiffres uniquement
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location = New-Object System.Drawing.Point(10, 70)
    $textbox.Width = 300
    $textbox.Font = New-Object System.Drawing.Font("Arial", 12)
    $textbox.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255)
    $textbox.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)
    $textbox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    # Ajouter un événement pour permettre uniquement les chiffres
    $textbox.Add_KeyPress({
        if ($_ -match '[^\d]' -and $_.KeyCode -ne [System.Windows.Forms.Keys]::Backspace) {
            $_.Handled = $true
        }
    })

    $form.Controls.Add($textbox)

    # Bouton de connexion
    $buttonLogin = New-Object System.Windows.Forms.Button
    $buttonLogin.Text = "Se connecter"
    $buttonLogin.Location = New-Object System.Drawing.Point(10, 110)
    $buttonLogin.Size = New-Object System.Drawing.Size(320, 40)
    $buttonLogin.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $buttonLogin.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
    $buttonLogin.ForeColor = [System.Drawing.Color]::White
    $buttonLogin.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $buttonLogin.Add_Click({
        $code = $textbox.Text
        if (Validate-Login $code) {
            $form.Close()  # Fermer la fenêtre de login
            Show-PlateauSelectionForm  # Appeler la fonction de sélection des plateaux
        }
    })
    $form.Controls.Add($buttonLogin)

    # Afficher la fenêtre de login
    $form.ShowDialog()
}

# Fonction pour exécuter un script basé sur le chemin relatif avec des privilèges administratifs
function Execute-Script {
    param (
        [string]$scriptName
    )

    # Vérification du chemin du script
    if (-not $PSScriptRoot) {
        # Si $PSScriptRoot est vide, utiliser le répertoire courant
        $scriptPath = Join-Path (Get-Location) $scriptName
    } else {
        # Sinon utiliser $PSScriptRoot
        $scriptPath = Join-Path $PSScriptRoot $scriptName
    }

    # Vérifier si le script existe avant de l'exécuter
    if (Test-Path $scriptPath) {
        # Exécution du script en mode administrateur
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb runAs  
    } else {
        [System.Windows.Forms.MessageBox]::Show("Le script n'existe pas à cet emplacement.")
    }
}

# Fonction pour afficher la page de sélection des plateaux
function Show-PlateauSelectionForm {
    # Création de la fenêtre de sélection de plateaux
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Sélection du Plateau Supprof"
    $form.Size = New-Object System.Drawing.Size(350, 300)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.BackColor = [System.Drawing.Color]::FromArgb(255, 240, 240)

    # Label pour indiquer le choix
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Choisissez un plateau :"
    $label.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $label.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Width = 300
    $form.Controls.Add($label)

    # Boutons de sélection pour chaque plateau
    $buttonLogiciel = New-Object System.Windows.Forms.Button
    $buttonLogiciel.Text = "Logiciel"
    $buttonLogiciel.Location = New-Object System.Drawing.Point(10, 60)
    $buttonLogiciel.Size = New-Object System.Drawing.Size(320, 40)
    $buttonLogiciel.Font = New-Object System.Drawing.Font("Arial", 12)
    $buttonLogiciel.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
    $buttonLogiciel.ForeColor = [System.Drawing.Color]::White
    $buttonLogiciel.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $buttonLogiciel.Add_Click({
        Execute-Script -scriptName "SupprofLogiciel.ps1"
    })
    $form.Controls.Add($buttonLogiciel)

    $buttonMateriel = New-Object System.Windows.Forms.Button
    $buttonMateriel.Text = "Matériel"
    $buttonMateriel.Location = New-Object System.Drawing.Point(10, 110)
    $buttonMateriel.Size = New-Object System.Drawing.Size(320, 40)
    $buttonMateriel.Font = New-Object System.Drawing.Font("Arial", 12)
    $buttonMateriel.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
    $buttonMateriel.ForeColor = [System.Drawing.Color]::White
    $buttonMateriel.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $buttonMateriel.Add_Click({
        Execute-Script -scriptName "SupprofMateriel.ps1"
    })
    $form.Controls.Add($buttonMateriel)

    $buttonReseau = New-Object System.Windows.Forms.Button
    $buttonReseau.Text = "Réseau"
    $buttonReseau.Location = New-Object System.Drawing.Point(10, 160)
    $buttonReseau.Size = New-Object System.Drawing.Size(320, 40)
    $buttonReseau.Font = New-Object System.Drawing.Font("Arial", 12)
    $buttonReseau.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
    $buttonReseau.ForeColor = [System.Drawing.Color]::White
    $buttonReseau.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $buttonReseau.Add_Click({
        Execute-Script -scriptName "SupprofReseau.ps1"
    })
    $form.Controls.Add($buttonReseau)

    # Afficher la fenêtre de sélection des plateaux
    $form.ShowDialog()
}

# Afficher la fenêtre de login
Show-LoginForm
