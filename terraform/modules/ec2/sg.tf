#===============================
# Security Group Frontend
#===============================
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Security Group for Frontend (Uptime Kuma)"
  vpc_id      = var.vpc_id
}
#-------------------------------
# Frontend Security Group Rules
#-------------------------------
# Allow inbound HTTP access for the public (Uptime Kuma)
resource "aws_security_group_rule" "frontend_ingress_http" {
  type              = "ingress"
  description       = "Allow inbound HTTP traffic from anywhere"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.frontend_sg.id
}
# Allow inbound SSH access (RESTRICTED TO SECURE CIDR)
resource "aws_security_group_rule" "frontend_ingress_ssh" {
  type              = "ingress"
  description       = "Allow inbound SSH traffic from management CIDR"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.frontend_sg.id
}
# Allow all outbound traffic
resource "aws_security_group_rule" "frontend_egress_all" {
  type              = "egress"
  description       = "Allow outbound traffic to anywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.frontend_sg.id
}

#===============================
# Security Group Backend
#===============================
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Security Group for Backend (API)"
  vpc_id      = var.vpc_id
}

#------------------------------
# Backend Security Group Rules
#------------------------------
# FIX: Allow inbound API traffic (Port 8000) from Frontend Security Group
resource "aws_security_group_rule" "backend_ingress_api" {
  type                     = "ingress"
  description              = "Allow inbound API traffic from Frontend Security Group"
  from_port                = 8000 # Corrected port
  to_port                  = 8000 # Corrected port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.frontend_sg.id
}
# Allow inbound SSH access (RESTRICTED TO SECURE CIDR)
resource "aws_security_group_rule" "backend_ingress_ssh" {
  type              = "ingress"
  description       = "Allow inbound SSH traffic from management CIDR"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr] # Use restricted CIDR
  security_group_id = aws_security_group.backend_sg.id
}
# Allow all outbound traffic
resource "aws_security_group_rule" "backend_egress_all" {
  type              = "egress"
  description       = "Allow outbound traffic to anywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_sg.id
}
# Egress Rule: Allow outbound MySQL traffic from backend to Database
resource "aws_security_group_rule" "backend_egress_to_database" {
  type                     = "egress"
  description              = "Allow outbound MySQL traffic from backend to Database SG"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.database_sg.id
}

#===============================
# Security Group Database
#===============================
resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Security Group for Database"
  vpc_id      = var.vpc_id
}

# Allow inbound MySQL traffic (3306) only from the Backend Security Group
resource "aws_security_group_rule" "database_ingress_from_backend" {
  type                     = "ingress"
  description              = "Allow inbound MySQL traffic from Backend Security Group"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.backend_sg.id
}
# Allow all outbound traffic (database needs to talk to the internet for updates/S3 etc)
resource "aws_security_group_rule" "database_egress_all" {
  type              = "egress"
  description       = "Allow outbound traffic to anywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database_sg.id
}