//TODO: Color the legacy/existing components that are integrated 1:1 in gray
workspace {
    model {
        candidate = person "Certification Candidate" "A candidate that is aiming to get professionally certified by Cerfifiable Inc.." "Candidate"
        expert = person "IT Expert" "IT Expert Grader, working for Certifiable Inc." "Expert"
		engineer = person "ML Engineer" "AI Engineer, working for Certifiable Inc." "ML Engineer"
		
		certifiableSystem = softwareSystem "Certifiable Inc. Existing Software System" {
			aptitudeTestTaker = container "Aptitude Test Taker" "Interface handling test loading, question sending, answer capturing and test timing" "Aptitude Test Taker"
            aptitudeAutoGrader = container "Aptitude Auto Grader" "Auto-grading component for multiple-choice questions" "Auto Grader"
            aptitudeManualCapture = container "Aptitude Manuel Capture" "Manual capture component for short-answer questions" "Manual Capture"
            database = container "Ungraded Database" "Contains the ungraded short-answer Q&A tuples" "" "Database"
            gradeddatabase = container "Graded Database" "Graded Exams Database, contains the aptitutde tests from previous 120k exams." "" "Database"
		}
		archifyAdapterSystem = softwareSystem "ARCHIFY Certification System Adapter" {
            adapter = container "Adapter" "Archify Adapter, parses exams from ungraded exams database" "Adapter"
            orchestrator = container "Prompt Orchestrator" "Archify Prompt Orchestrator" "Prompt Orchestrator"
            vectordatabase = container "Vector Database" "Vector Database with Q&A tuples" "" "Vector Database"
		}

		llm = softwareSystem "LLM Model" {
            guardrails = container "Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Guardrails"
			llmodel = container "Model" "External LLM API" "Model"
		}

		updateVectorDB = softwareSystem "Update Job for Vector DB" {
			updater = container "Update Job" "Updates the Vector DB periodically with new Q&A tuples" "Update Job"
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
		candidate -> certifiableSystem "Takes aptitude certification exam, consisting of multiple-choice and short-answer tests"
        expert -> certifiableSystem "Grades short-answer tests, provides feedback. Analyses question catalog."
		engineer -> archifyAdapterSystem "Maintains LLM components used for auto-grading, including monitoring, parameter and threshold tuning, updating models etc."
		archifyAdapterSystem -> certifiableSystem "Provides databases with ungraded exam questions and graded exam database"

		// Containers 
		// Existing System
		aptitudeTestTaker -> aptitudeManualCapture "Passes short-answer questions"
		aptitudeTestTaker -> aptitudeAutoGrader "Passes multiple-choice questions to auto-grader"
		aptitudeAutoGrader -> gradeddatabase "Writes multiple-choice question answers and results"
		aptitudeManualCapture -> database "Forwards ungraded Q&A tuples"

		// Update Job
		gradeddatabase -> updater "Reads new graded Q&A tuples from the database via high watermark (timestamp column)"
		updater -> vectordatabase "Embedds the new Q&A tuples into vector space and writes them to Vector Database"

		// New LLM grading System
		database -> adapter "reads ungraded aptitude test exams"
		adapter -> orchestrator "Provides Q&A tuple"
		adapter -> gradeddatabase "Returns graded Q&A tuples with feedback"
		orchestrator -> adapter "Returns LLM grading"
		orchestrator -> guardrails "Forwards prompt to be checked"
		guardrails -> orchestrator "Compares against expected output format and checks for schema compatibility"
		vectordatabase -> orchestrator "Enriches prompt by providing most similar Q&A tuples"
		llmodel -> guardrails "Returns generated output by LLM"
		guardrails -> llmodel "Analyses for input injection attacks"
    }

    views {
        systemContext certifiableSystem {
            include * engineer
			autoLayout
        }
		container archifyAdapterSystem "Containers" {
            include updater aptitudeTestTaker aptitudeManualCapture aptitudeAutoGrader database gradeddatabase adapter orchestrator vectordatabase guardrails llmodel
            description "Container diagram for the existing components interacting with the ARCHIFY extensions"
			autoLayout
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Candidate" {
                background #a94064
            }
            element "Expert" {
                background #e7004c
            }
            element "ML Engineer" {
                background #e7004c
            }
            element "Software System" {
                background #0065a1
                color #ffffff
            }
            element "Database" {
                background #85bbf0
                shape Cylinder
            }
            element "Vector Database" {
                background #85bbf0
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
