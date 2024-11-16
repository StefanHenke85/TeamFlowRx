= Projekt-Dokumentation für Entwickler und Administratoren
:sectnums:
:toc:

== Einführung

Dieses Dokument dient als Anleitung für Entwickler und Administratoren zur Verwaltung und Wartung der AWS-Infrastruktur, 
die mit Terraform und Ansible bereitgestellt wurde. Es enthält detaillierte Informationen zu den Modulen, zur Struktur und zur Nutzung der Konfigurationstools.

== Architekturübersicht

Die AWS-Infrastruktur besteht aus folgenden Hauptkomponenten:

* S3 und CloudFront: Für das Hosting von statischen Inhalten und als Content Delivery Network (CDN).
* Cognito: Für die Authentifizierung und Verwaltung von Benutzern.
* RDS MySQL: Als Datenbank für persistente Speicherung, eingeschränkt zugänglich über Sicherheitsgruppen.
* API Gateway: Zum Bereitstellen von RESTful APIs, die entweder mit Lambda oder EC2 integriert sind.
* Compute (Lambda oder EC2): Bereitstellung der Backend-Logik, je nach Architekturbedarf.
* CloudWatch: Monitoring und Alarmierung zur Infrastrukturüberwachung und Fehlererkennung.

== Terraform Nutzung

Terraform wird verwendet, um die AWS-Infrastruktur als Code (IaC) bereitzustellen und zu verwalten. 
Im Folgenden sind die grundlegenden Schritte zur Verwaltung und Aktualisierung der Infrastruktur beschrieben.

=== Voraussetzungen

* Installiertes Terraform (mindestens Version 1.x) und AWS CLI.
* Zugangsdaten für AWS mit den entsprechenden Berechtigungen (z. B. Admin-Zugang).
* Ein S3-Bucket für den Terraform-Backend-State (zur Speicherung des Infrastrukturstatus).

=== Wichtige Terraform-Befehle

1. **Initialisierung**:
   Führen Sie `terraform init` im Projektverzeichnis aus, um die benötigten Provider und Module zu laden und den Backend-State zu konfigurieren.

2. **Planung**:
   Nutzen Sie `terraform plan`, um Änderungen vorzubereiten und zu überprüfen. Dies zeigt eine Vorschau der Änderungen, bevor sie tatsächlich angewendet werden.

3. **Anwenden**:
   Verwenden Sie `terraform apply`, um die Infrastrukturänderungen in AWS umzusetzen. Bestätigen Sie die Aktion, um den Prozess zu starten.

4. **Rückgängig machen**:
   Falls nötig, können Sie `terraform destroy` ausführen, um die gesamte Infrastruktur zu entfernen (mit Vorsicht verwenden, nur bei Bedarf).

=== Module

Die Terraform-Konfiguration ist modular aufgebaut, um die Wiederverwendbarkeit zu maximieren und die Struktur zu vereinfachen. 
Jedes Modul (z. B. `s3_cloudfront`, `cognito`, `rds_mysql`, etc.) ist in einem eigenen Verzeichnis und enthält spezifische Konfigurationsdateien (`main.tf`, `variables.tf`, `outputs.tf`).

Jeder Aufruf eines Moduls wird in der Hauptkonfigurationsdatei (`main.tf`) referenziert.

=== Variablen und Outputs

Variablen sind in den `variables.tf`-Dateien der Module definiert und erleichtern die Anpassung der Module an verschiedene Umgebungen (z. B. Entwicklung, Staging, Produktion). 
Outputs sind in den `outputs.tf`-Dateien festgelegt und helfen dabei, relevante Ressourceninformationen zu exportieren (z. B. Endpunkte, IDs).

== Ansible Nutzung

Ansible wird verwendet, um die Konfiguration und Wartung der EC2-Instanzen zu automatisieren. 
Dies umfasst die Installation benötigter Software (z. B. Docker, Node.js) und die Bereitstellung der Backend-Anwendungen.

=== Voraussetzungen

* Installiertes Ansible und SSH-Zugriff auf die EC2-Instanzen.
* SSH-Schlüssel, die in AWS als Key-Pair eingerichtet und in Ansible für den Zugriff auf die EC2-Instanzen konfiguriert sind.

=== Wichtige Playbooks

1. **EC2-Setup**:
   Ein Playbook zur Installation von Node.js, Docker und anderen Abhängigkeiten auf den EC2-Instanzen. Beispiel:

   ```yaml
   ---
   - name: Setup EC2 instances
     hosts: ec2
     become: yes
     tasks:
       - name: Install Node.js
         yum:
           name: nodejs
           state: present
       - name: Install Docker
         yum:
           name: docker
           state: present
       - name: Start Docker
         service:
           name: docker
           state: started
Backend-Deployment: Ein Playbook zur Bereitstellung und zum Starten der Backend-Docker-Container. Beispiel:

yaml
Code kopieren
---
- name: Deploy backend
  hosts: ec2
  become: yes
  tasks:
    - name: Copy Docker compose file
      copy:
        src: ./docker-compose.yml
        dest: /home/ec2-user/docker-compose.yml
    - name: Start Docker container
      command: docker-compose up -d
Wartung: Playbook zur regelmäßigen Aktualisierung der Instanzen und zur Installation von Sicherheits-Patches.

yaml
Code kopieren
---
- name: Perform system updates
  hosts: ec2
  become: yes
  tasks:
    - name: Update all packages
      yum:
        name: "*"
        state: latest
== Fehlerbehebung und Monitoring

CloudWatch Logs: Die Log-Gruppen für Lambda und API Gateway sind in CloudWatch verfügbar und ermöglichen es, Fehler und Anfragen zu analysieren.
Alarme: Bei einer hohen CPU-Auslastung oder API-Fehlern werden Alarme ausgelöst, die über ein SNS-Topic an Administratoren gemeldet werden.
Log-Retention: Die Log-Aufbewahrungszeit ist auf 7 Tage festgelegt, kann jedoch bei Bedarf angepasst werden.
== Sicherheitsüberlegungen

IAM-Rollen: Die Lambda-Funktionen und EC2-Instanzen sind auf die minimal notwendigen Berechtigungen beschränkt (Least Privilege Principle).
Sicherheitsgruppen: Zugriff auf die Datenbank und andere sensible Dienste ist durch Sicherheitsgruppen beschränkt.
Secrets Management: Falls sensible Informationen wie Passwörter verwendet werden, können AWS Secrets Manager oder Parameter Store integriert werden.
== Änderung und Erweiterung der Infrastruktur

Falls Änderungen an der Infrastruktur erforderlich sind (z. B. neue Module, Konfigurationsanpassungen), sollten die folgenden Schritte beachtet werden:

Änderungen vorbereiten: Bearbeiten Sie die entsprechenden Module oder Variablen und verwenden Sie terraform plan, um die Auswirkungen zu überprüfen.
Code-Versionierung: Alle Änderungen sollten in einem Versionskontrollsystem (z. B. Git) verfolgt werden.
Tests und Validierung: Führen Sie Tests in einer Entwicklungsumgebung durch, bevor Änderungen in die Produktionsumgebung übernommen werden.
== Kontakt und Support

Für weitere Unterstützung und Informationen wenden Sie sich an das DevOps-Team oder den Projektverantwortlichen.