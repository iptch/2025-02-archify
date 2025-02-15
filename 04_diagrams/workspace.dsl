workspace {
    model {
        candidate = person "Certification Candidate" "A candidate that is aiming to get professionally certified." "Candidate"
        expert = person "IT Expert" "IT Expert Grader, hired by Certifiable Inc." "Expert"
		engineer = person "ML Engineer" "AI Engineer, hired by Certifiable Inc." "ML Engineer"
		
		certifiableSystem = softwareSystem "Certifiable Inc. Existing Software System" {
            test = container "Adapter" "Archify Adapter, parses exams from ungraded exams database" "Adapter"
            database = container "database" "Ungraded exams database" "TODO database Schema" "database"
		}
		archifyAdapterSystem = softwareSystem "ARCHIFY Certification System Adapter" {
            adapter = container "Adapter" "Archify Adapter, parses exams from ungraded exams database" "Adapter"
            orchestrator = container "Prompt Orchestrator" "Archify Prompt Orchestrator" "Prompt Orchestrator"
            vectordatabase = container "Vector Database" "TODO" "database"
		}

		llm = softwareSystem "LLM Model" {
            guardrails = container "Guardrails Component" "TODO" "Guardrails"
			llmodel = container "Model" "TODO" "Model"
		}

/*
		group "Software System" {
			ss = softwareSystem "Certifiable Inc. Software System" 
			archify = softwareSystem "ARCHIFY Auto Grading System" {
				autograder = container "Container" {
					vectordatabase = component "database" "Ungraded exams" "database"
					prompt2Orchestrator = component "Prompt Orchestrator"
					llm = component "LLM Model"
				}
				ungradeddatabase = container "database" "Ungraded exams" "database"
			}
			aptituteManualGrader = softwareSystem "Aptitude Manuel Grader"
		}
*/		
		// People and Software Systems
		candidate -> certifiableSystem "Solves certification exams"
        expert -> certifiableSystem "Grades Exams, Analyses the question and case study catalog"
		engineer -> archifyAdapterSystem "Monitors, Parameter Tuning, Change Models etc."
		archifyAdapterSystem -> certifiableSystem "Provides ungraded exams and exam database"

		// Containers
		database -> adapter "reads ungraded aptitude test exams"
		adapter -> orchestrator "Provides Q&A tuple"
		orchestrator -> adapter "Returns LLM grading"
		orchestrator -> guardrails "Checks for injection attacks"
		guardrails -> orchestrator "Checks for database schema compatibility"
		vectordatabase -> orchestrator "Enriches prompt by providing most similar Q&A tuples"
		llmodel -> guardrails "Forwards"
		guardrails -> llmodel
    }

    views {
        systemContext certifiableSystem {
            include * engineer
            autolayout
        }
		container archifyAdapterSystem "Containers" {
            include database adapter orchestrator vectordatabase guardrails llmodel
            autoLayout
            description "TODO"
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Candidate" {
                background #e7004c
            }
            element "Expert" {
                background #e7004c

            }
            element "Software System" {
                background #0065a1
                color #ffffff
            }
            element "database" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
        }

    }
    
}
