
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  provider = aws.seoul
  replication_subnet_group_id   = "dms-subnet-group"
  replication_subnet_group_description = "DMS subnet group"
  subnet_ids = [aws_subnet.CV_private_seoul_a.id, aws_subnet.CV_private_seoul_c.id]  # VPC 서브넷 ID 입력
}

resource "aws_dms_replication_subnet_group" "dms_subnet_group_us" {
  provider = aws.virginia
  replication_subnet_group_id   = "dms-subnet-group-us"
  replication_subnet_group_description = "DMS subnet group us"
  subnet_ids = [aws_subnet.CV_private_virginia_a.id, aws_subnet.CV_private_virginia_c.id]  # VPC 서브넷 ID 입력
}

resource "aws_dms_replication_instance" "dms_instance" {
  provider                     = aws.seoul
  replication_instance_id       = "dms-instance-1"  # ✅ ID 추가
  replication_instance_class    = "dms.t3.medium"
  allocated_storage            = 20
  publicly_accessible          = true  # 온프레미스 연결 허용
  engine_version     = "3.5.2"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id
  vpc_security_group_ids = [aws_security_group.aurora_sg.id, aws_default_security_group.default_sg_ko.id]
}

# resource "aws_dms_replication_instance" "dms_instance_us" {
#   provider                     = aws.virginia
#   replication_instance_id       = "dms-instance-2"  # ✅ ID 추가
#   replication_instance_class    = "dms.t3.medium"
#   allocated_storage            = 20
#   publicly_accessible          = true  # 온프레미스 연결 허용
#   engine_version     = "3.5.2"
#   replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group_us.id
#   vpc_security_group_ids = [aws_security_group.aurora_sg_us, aws_default_security_group.default_sg_us]
# }

resource "aws_dms_endpoint" "source_seoul" {
  provider       = aws.seoul
  endpoint_id    = "source-seoul-mysql"  # ✅ ID 추가
  endpoint_type  = "source"
  engine_name    = "mysql"
  username       = "superadmin"
  password       = "qwer!234"
  server_name    = "aurora-instance-1.c7ysko60qnfo.ap-northeast-2.rds.amazonaws.com"
  port           = 3306
  ssl_mode       = "none"
}

# resource "aws_dms_endpoint" "source_virginia" {
#   provider       = aws.virginia
#   endpoint_id    = "source-virginia-mysql"  # ✅ ID 추가
#   endpoint_type  = "source"
#   engine_name    = "mysql"
#   username       = "superadmin"
#   password       = "qwer!234"
#   server_name    = aws_db_instance.aurora_instance_us.address
#   port           = 3306
# }

resource "aws_dms_endpoint" "target_onprem" {
  endpoint_id    = "target-onprem-mysql"  # ✅ ID 추가
  endpoint_type  = "target"
  engine_name    = "mysql"
  username       = "superadmin"
  password       = "qwer!234"
  server_name    = "192.168.10.12"  # 온프레미스 VMware 내부 IP
  port           = 3306
  ssl_mode       = "none"
}




resource "aws_dms_replication_task" "migration_seoul" {
  migration_type          = "full-load"
  replication_task_id     = "mysql-migration-seoul"
  replication_instance_arn = aws_dms_replication_instance.dms_instance.replication_instance_arn
  source_endpoint_arn     = aws_dms_endpoint.source_seoul.endpoint_arn
  target_endpoint_arn     = aws_dms_endpoint.target_onprem.endpoint_arn

  table_mappings = <<EOF
  {
	"rules": [
	  {
		"rule-type": "selection",
		"rule-id": "1",
		"rule-name": "include-boyageDB",
		"object-locator": {
		  "schema-name": "boyageDB",
		  "table-name": "%"
		},
		"rule-action": "include"
	  }
	]
  }
  EOF

	replication_task_settings = <<EOF
	{
	  "TargetMetadata": {
		"TargetSchema": "",
		"SupportLobs": true,
		"FullLobMode": false,
		"LobChunkSize": 64,
		"LimitedSizeLobMode": true,
		"LobMaxSize": 32,
		"EnableSchemaDetection": true,
		"CreateTables": true
	  },
	  "FullLoadSettings": {
		"TargetTablePrepMode": "DO_NOTHING",
		"CreatePkAfterFullLoad": true,
		"StopTaskCachedChangesApplied": false,
		"StopTaskCachedChangesNotApplied": false,
		"MaxFullLoadSubTasks": 8,
		"TransactionConsistencyTimeout": 600,
		"CommitRate": 10000
	  },
	  "ChangeProcessingDdlHandlingPolicy": {
		"HandleSourceTableDropped": true,
		"HandleSourceTableTruncated": true,
		"HandleSourceTableAltered": true
	  },
	  "ChangeProcessingTuning": {
		"CommitTimeout": 10,
		"MemoryLimitTotal": 2048
	  },
	  "Logging": {
		"EnableLogging": true
	  },
	  "ControlTablesSettings": {
		"ControlSchema": "dms_control",
		"StatusTableEnabled": true, 
		"HistoryTableEnabled": true
	  },
	  "ErrorBehavior": {
		"FailOnNoTablesCaptured": true,
		"ApplyErrorEscalationPolicy": "LOG_ERROR",
		"DataErrorEscalationPolicy": "SUSPEND_TABLE",
		"TableErrorEscalationPolicy": "SUSPEND_TABLE",
		"RecoverableErrorThrottling": true,
		"RecoverableErrorInterval": 5
	  }
	}
	EOF
}




# resource "aws_route" "CV_seoul_to_onprem" {
#   provider               = aws.seoul
#   route_table_id         = aws_route_table.CV_seoul_private_rt.id
#   destination_cidr_block = "192.168.10.0/24"  # 온프레미스 서브넷
#   transit_gateway_id     = aws_ec2_transit_gateway.CV_seoul_tgw.id
# }

# resource "aws_route" "CV_virginia_to_onprem" {
#   provider               = aws.virginia
#   route_table_id         = aws_route_table.CV_virginia_private_rt.id
#   destination_cidr_block = "192.168.10.0/24"  # 온프레미스 서브넷
#   transit_gateway_id     = aws_ec2_transit_gateway.CV_virginia_tgw.id
# }

# # resource "aws_vpn_connection_route" "CV_seoul_vpn_route" {
# #   destination_cidr_block = "192.168.1.0/24"  # 온프레미스 서브넷
# #   vpn_connection_id      = aws_vpn_connection.CV_seoul_vpn.id
# # }

# # resource "aws_vpn_connection_route" "CV_virginia_vpn_route" {
# #   destination_cidr_block = "192.168.1.0/24"  # 온프레미스 서브넷
# #   vpn_connection_id      = aws_vpn_connection.CV_virginia_vpn.id
# # }
