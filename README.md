# TeamFlowRX - infrastrukturprojekt

## projektübersicht

teamflowrx ist eine cloud-basierte infrastruktur, die auf **aws** gehostet wird und für die bereitstellung und das management von ressourcen konzipiert ist, um eine skalierbare und sichere umgebung zu gewährleisten. mit **terraform** und **ansible** automatisieren wir die bereitstellung und verwaltung der infrastruktur, während ein **ci/cd-workflow** mit **github actions** sicherstellt, dass änderungen nahtlos und zuverlässig implementiert werden.

**ziele des projekts:**
- bereitstellung einer vollständig skalierbaren infrastruktur auf aws.
- sicherstellung der konsistenz und wiederholbarkeit durch infrastruktur als code (iac).
- automatisierte einrichtung und wartung der entwicklungs-, staging- und produktionsumgebungen.

---

## setup- und bereitstellungsanweisungen

### voraussetzungen

stellen sie sicher, dass die folgenden voraussetzungen erfüllt sind:
- **aws-konto**: für den zugriff und die verwaltung der aws-ressourcen.
- **aws cli**: installieren und konfigurieren sie die aws cli mit den entsprechenden anmeldedaten.
- **terraform**: installieren sie terraform ([anleitung](https://learn.hashicorp.com/tutorials/terraform/install-cli)).
- **ansible**: installieren sie ansible ([anleitung](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)).

### 1. terraform-bereitstellung

#### schritte zur bereitstellung

1. **aws zugangsdaten konfigurieren**:
   - speichern sie die aws zugangsdaten (access key und secret key) in ihrer umgebung oder verwenden sie `aws configure`, um die berechtigungen festzulegen.

2. **terraform initialisieren und anwenden**:
   - gehen sie in das verzeichnis, in dem sich die `main.tf` datei befindet, und führen sie die folgenden befehle aus:
     ```bash
     terraform init
     terraform apply
     ```
   - terraform wird alle notwendigen ressourcen bereitstellen, einschließlich iam-rollen, cloudwatch-logs und -alarme, ec2-instanzenn und weiteren ressourcen, die in den modulen definiert sind.
   - bestätigen sie die bereitstellung, indem sie `yes` eingeben, wenn terraform nach einer bestätigung fragt.

3. **terraform variablen anpassen**:
   - die umgebung kann über die `environment` variable angepasst werden (z. b. `dev`, `staging`, `prod`). dies kann durch anpassung der variablen im code oder durch angabe beim befehl geschehen:
     ```bash
     terraform apply -var="environment=prod"
     ```

#### wichtige terraform-dateien

- **`main.tf`**: orchestriert die module und definiert die hauptressourcen.
- **`variables.tf`**: definiert die globalen variablen für das projekt.
- **`outputs.tf`**: stellt wichtige outputs zur verfügung, wie die arns der erstellten ressourcen.

### 2. ansible-playbooks

#### ausführung der ansible-playbooks

1. **ec2-setup playbook**:
   - dieses playbook installiert und konfiguriert die grundlegenden softwarekomponenten auf den ec2-instanzenn, einschließlich docker, node.js und dem cloudwatch-agent.
     ```bash
     ansible-playbook playbooks/ec2_setup.yml
     ```

2. **backend-deployment playbook**:
   - das backend-deployment-playbook stellt das backend mithilfe von docker-containern bereit und startet den container mit den korrekten umgebungsvariablen.
     ```bash
     ansible-playbook playbooks/backend_deploy.yml
     ```

3. **wartungs-playbook**:
   - das wartungs-playbook führt regelmäßige system-updates durch, bereinigt docker-container und prüft die systemgesundheit.
     ```bash
     ansible-playbook playbooks/maintenance.yml
     ```

#### wichtige ansible-dateien

- **`ec2_setup.yml`**: initiales setup für die ec2-instanzenn.
- **`backend_deploy.yml`**: deployment des backend-containers.
- **`maintenance.yml`**: wartung und updates für die instanzenn.

---

## verwendung des ci/cd-workflows

### github actions workflow für terraform

der ci/cd-workflow ist so eingerichtet, dass er bei push-events auf den `main`-branch ausgeführt wird. der workflow automatisiert die bereitstellung der terraform-infrastruktur und stellt sicher, dass änderungen an den konfigurationsdateien automatisch angewendet werden.

#### funktionsweise des workflows

**workflow-trigger:**
- der workflow wird ausgelöst, wenn änderungen an den terraform-dateien im `main`-branch vorgenommen und gepusht werden.

**workflow-schritte:**
1. **checkout repository**: der code wird aus dem github-repository in den workflow-runner geladen.
2. **aws credentials konfigurieren**: die aws zugangsdaten werden aus den secrets abgerufen und für terraform-befehle verwendet.
3. **terraform initialisieren**: `terraform init` wird ausgeführt, um das projekt vorzubereiten.
4. **terraform plan**: `terraform plan` generiert einen plan der infrastrukturänderungen.
5. **terraform apply**: `terraform apply` führt die änderungen auf den aws-ressourcen aus.

#### konfiguration der github actions secrets

um den workflow korrekt auszuführen, sind folgende secrets in den github repository-einstellungen erforderlich:
- **`aws_access_key_id`**: der aws access key für die berechtigungen.
- **`aws_secret_access_key`**: der secret access key für den aws-zugriff.
- **`aws_region`**: die aws-region, in der die ressourcen bereitgestellt werden (z. b. `us-east-1`).

#### anpassungen am workflow

falls anpassungen erforderlich sind, können sie die workflow-datei `.github/workflows/terraform.yml` entsprechend bearbeiten, um zusätzliche schritte oder anpassungen für spezifische anforderungen hinzuzufügen.

---

## fehlerbehebung und support

falls probleme auftreten, finden sie hier einige häufige fehler und deren lösungen:
- **fehlende aws-berechtigungen**: stellen sie sicher, dass die iam-rolle die erforderlichen berechtigungen für die aktionen in terraform und ansible hat.
- **github actions fehler bei secrets**: prüfen sie, ob alle secrets korrekt konfiguriert sind.
- **timeouts oder fehlgeschlagene ressourcen**: stellen sie sicher, dass die aws-region korrekt gesetzt ist und dass die ec2-instanzenn und anderen ressourcen korrekt erreichbar sind.

---

## weitere ressourcen

- [terraform dokumentation](https://www.terraform.io/docs)
- [ansible dokumentation](https://docs.ansible.com)
- [github actions dokumentation](https://docs.github.com/actions)

---

## kontakt und support

falls sie fragen haben oder unterstützung benötigen, wenden sie sich bitte an das devops-team.
