# TeamFlowRX - Infrastrukturprojekt

## Projektübersicht

TeamFlowRX ist eine Cloud-basierte Infrastruktur, die auf **AWS** gehostet wird und für die Bereitstellung und das Management von Ressourcen konzipiert ist, um eine skalierbare und sichere Umgebung zu gewährleisten. Mit **Terraform** und **Ansible** automatisieren wir die Bereitstellung und Verwaltung der Infrastruktur, während ein **CI/CD-Workflow** mit **GitHub Actions** sicherstellt, dass Änderungen nahtlos und zuverlässig implementiert werden.

**Ziele des Projekts:**
- Bereitstellung einer vollständig skalierbaren Infrastruktur auf AWS.
- Sicherstellung der Konsistenz und Wiederholbarkeit durch Infrastruktur als Code (IaC).
- Automatisierte Einrichtung und Wartung der Entwicklungs-, Staging- und Produktionsumgebungen.

---

## Setup- und Bereitstellungsanweisungen

### Voraussetzungen

Stellen Sie sicher, dass die folgenden Voraussetzungen erfüllt sind:
- **AWS-Konto**: Für den Zugriff und die Verwaltung der AWS-Ressourcen.
- **AWS CLI**: Installieren und konfigurieren Sie die AWS CLI mit den entsprechenden Anmeldeinformationen.
- **Terraform**: Installieren Sie Terraform ([Anleitung](https://learn.hashicorp.com/tutorials/terraform/install-cli)).
- **Ansible**: Installieren Sie Ansible ([Anleitung](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)).

### 1. Terraform-Bereitstellung

#### Schritte zur Bereitstellung

1. **AWS Zugangsdaten konfigurieren**:
   - Speichern Sie die AWS Zugangsdaten (Access Key und Secret Key) in Ihrer Umgebung oder verwenden Sie `aws configure`, um die Berechtigungen festzulegen.

2. **Terraform Initialisieren und Anwenden**:
   - Gehen Sie in das Verzeichnis, in dem sich die `main.tf` Datei befindet, und führen Sie die folgenden Befehle aus:
     ```bash
     terraform init
     terraform apply
     ```
   - Terraform wird alle notwendigen Ressourcen bereitstellen, einschließlich IAM-Rollen, CloudWatch-Logs und -Alarme, EC2-Instanzen und weiteren Ressourcen, die in den Modulen definiert sind.
   - Bestätigen Sie die Bereitstellung, indem Sie `yes` eingeben, wenn Terraform nach einer Bestätigung fragt.

3. **Terraform Variablen anpassen**:
   - Die Umgebung kann über die `environment` Variable angepasst werden (z.B. `dev`, `staging`, `prod`). Dies kann durch Anpassung der Variablen im Code oder durch Angabe beim Befehl geschehen:
     ```bash
     terraform apply -var="environment=prod"
     ```

#### Wichtige Terraform-Dateien

- **`main.tf`**: Orchestriert die Module und definiert die Hauptressourcen.
- **`variables.tf`**: Definiert die globalen Variablen für das Projekt.
- **`outputs.tf`**: Stellt wichtige Outputs zur Verfügung, wie die ARNs der erstellten Ressourcen.

### 2. Ansible-Playbooks

#### Ausführung der Ansible-Playbooks

1. **EC2-Setup Playbook**:
   - Dieses Playbook installiert und konfiguriert die grundlegenden Softwarekomponenten auf den EC2-Instanzen, einschließlich Docker, Node.js und dem CloudWatch-Agent.
   ```bash
   ansible-playbook playbooks/ec2_setup.yml
Backend-Deployment Playbook:

Das Backend-Deployment-Playbook stellt das Backend mithilfe von Docker-Containern bereit und startet den Container mit den korrekten Umgebungsvariablen.
bash
Code kopieren
ansible-playbook playbooks/backend_deploy.yml
Wartungs-Playbook:

Das Wartungs-Playbook führt regelmäßige System-Updates durch, bereinigt Docker-Container und prüft die Systemgesundheit.
bash
Code kopieren
ansible-playbook playbooks/maintenance.yml
Wichtige Ansible-Dateien
ec2_setup.yml: Initiales Setup für die EC2-Instanzen.
backend_deploy.yml: Deployment des Backend-Containers.
maintenance.yml: Wartung und Updates für die Instanzen.
Verwendung des CI/CD-Workflows
GitHub Actions Workflow für Terraform
Der CI/CD-Workflow ist so eingerichtet, dass er bei Push-Events auf den main-Branch ausgeführt wird. Der Workflow automatisiert die Bereitstellung der Terraform-Infrastruktur und stellt sicher, dass Änderungen an den Konfigurationsdateien automatisch angewendet werden.

Funktionsweise des Workflows
Workflow-Trigger:

Der Workflow wird ausgelöst, wenn Änderungen an den Terraform-Dateien im main-Branch vorgenommen und gepusht werden.
Workflow-Schritte:

Checkout Repository: Der Code wird aus dem GitHub-Repository in den Workflow-Runner geladen.
AWS Credentials konfigurieren: Die AWS Zugangsdaten werden aus den Secrets abgerufen und für Terraform-Befehle verwendet.
Terraform Initialisieren: terraform init wird ausgeführt, um das Projekt vorzubereiten.
Terraform Plan: terraform plan generiert einen Plan der Infrastrukturänderungen.
Terraform Apply: terraform apply führt die Änderungen auf den AWS-Ressourcen aus.
Konfiguration der GitHub Actions Secrets
Um den Workflow korrekt auszuführen, sind folgende Secrets in den GitHub Repository-Einstellungen erforderlich:

AWS_ACCESS_KEY_ID: Der AWS Access Key für die Berechtigungen.
AWS_SECRET_ACCESS_KEY: Der Secret Access Key für den AWS-Zugriff.
AWS_REGION: Die AWS-Region, in der die Ressourcen bereitgestellt werden (z. B. us-east-1).
Anpassungen am Workflow
Falls Anpassungen erforderlich sind, können Sie die Workflow-Datei .github/workflows/terraform.yml entsprechend bearbeiten, um zusätzliche Schritte oder Anpassungen für spezifische Anforderungen hinzuzufügen.

Fehlerbehebung und Support
Falls Probleme auftreten, finden Sie hier einige häufige Fehler und deren Lösungen:

Fehlende AWS-Berechtigungen: Stellen Sie sicher, dass die IAM-Rolle die erforderlichen Berechtigungen für die Aktionen in Terraform und Ansible hat.
GitHub Actions Fehler bei Secrets: Prüfen Sie, ob alle Secrets korrekt konfiguriert sind.
Timeouts oder fehlgeschlagene Ressourcen: Stellen Sie sicher, dass die AWS-Region korrekt gesetzt ist und dass die EC2-Instanzen und anderen Ressourcen korrekt erreichbar sind.
Weitere Ressourcen
Terraform Dokumentation
Ansible Dokumentation
GitHub Actions Dokumentation
Kontakt und Support
Falls Sie Fragen haben oder Unterstützung benötigen, wenden Sie sich bitte an das DevOps-Team.

yaml
Code kopieren

---

Dies ist die vollständige README-Datei im Markdown-Format. Diese Datei enthält eine umfassende Dokumentation des Projekts und ermöglicht es jedem, das Setup zu verstehen und effektiv zu nutzen.