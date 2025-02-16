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
            aptitudeUngradedDatabase = container "Ungraded Database" "Contains the ungraded short-answer Q&A tuples" "" "Database"
            aptitudeGradedDatabase = container "Graded Database" "Graded Exams Database, contains the aptitutde tests from previous 120k exams." "" "Database"
		}
		archifySystem = softwareSystem "ARCHIFY AI Certification Systems" {
            aptitudeGradingAdapter = container "Adapter" "Archify Adapter, parses exams from ungraded exams database" "Adapter"
            aptitudePromtOrchestrator = container "Prompt Orchestrator" "Archify Prompt Orchestrator" "Prompt Orchestrator"
            aptitudeVectorDatabase = container "Aptitude Q&A \n Vector Database" "Aptitude Q&A Vector Database with Q&A tuples" "" "Aptitude Q&A Vector Database"
		}

		llm = softwareSystem "LLM Model" {
            aptitudeGuardrails = container "Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Guardrails"
			llmodel = container "Model" "External LLM API" "Model"
		}

		updateVectorDB = softwareSystem "Context Data Pre-Processing" {
			updater = container "Data Pipeline" "Updates the Vector DB periodically with new Q&A tuples" "Data Pipeline"
		}
	
		// People and Software Systems
		candidate -> certifiableSystem "Takes aptitude certification exam, consisting of multiple-choice and short-answer tests"
        expert -> certifiableSystem "Grades short-answer tests, provides feedback. Analyses question catalog."
		engineer -> archifySystem "Maintains LLM components used for auto-grading, including monitoring, parameter and threshold tuning, updating models etc."
		archifySystem -> certifiableSystem "Provides databases with ungraded exam questions and graded exam database"

		// Containers 
		// Existing System
		aptitudeTestTaker -> aptitudeManualCapture "Passes short-answer questions"
		aptitudeTestTaker -> aptitudeAutoGrader "Passes multiple-choice questions to auto-grader"
		aptitudeAutoGrader -> aptitudeGradedDatabase "Writes multiple-choice question answers and results"
		aptitudeManualCapture -> aptitudeUngradedDatabase "Forwards ungraded Q&A tuples"

		// Data Pipeline
		aptitudeGradedDatabase -> updater "Reads new graded Q&A tuples from the database via high watermark (timestamp column)"
		updater -> aptitudeVectorDatabase "Embedds the new Q&A tuples into vector space and writes them to Aptitude Q&A Vector Database"

		// New LLM grading System
		aptitudeUngradedDatabase -> aptitudeGradingAdapter "reads ungraded aptitude test exams"
		aptitudeGradingAdapter -> aptitudePromtOrchestrator "Provides Q&A tuple"
		aptitudeGradingAdapter -> aptitudeGradedDatabase "Returns graded Q&A tuples with feedback"
		aptitudePromtOrchestrator -> aptitudeGradingAdapter "Returns LLM grading"
		aptitudePromtOrchestrator -> aptitudeGuardrails "Forwards prompt to be checked"
		aptitudeGuardrails -> aptitudePromtOrchestrator "Compares against expected output format and checks for schema compatibility"
		aptitudeVectorDatabase -> aptitudePromtOrchestrator "Enriches prompt by providing most similar Q&A tuples"
		llmodel -> aptitudeGuardrails "Returns generated output by LLM"
		aptitudeGuardrails -> llmodel "Analyses for input injection attacks"
    }

    views {
        systemContext certifiableSystem {
            include * engineer
			autoLayout
        }
		container archifySystem "Containers" {
            include updater aptitudeTestTaker aptitudeManualCapture aptitudeAutoGrader aptitudeUngradedDatabase aptitudeGradedDatabase aptitudeGradingAdapter aptitudePromtOrchestrator aptitudeVectorDatabase aptitudeGuardrails llmodel
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
            element "Aptitude Q&A Vector Database" {
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
