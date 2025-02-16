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

            certifiableArchGrading = container "Certifiable Architecture Exams Module" {
                archSubmissionService = component "Architecture Submission Service" "" "Architecture Manual Grader"
                archManualGrader = component "Architecture Manual Grader" "" "Architecture Manual Grader"
                archCaseStudyDatabase = component "Case Study Database" "Database, contains case studies." "" "Database"
                archSubmissionUngradedDatabase = component "Submission Ungraded Database" "Ungraded Exams Database, contains the architecture submissions from previous 120k exams." "" "Database"
                archSubmissionGradedDatabase = component "Submission Graded Database" "Graded Exams & Feedback Database, contains the graded architecture submissions and feedback from previous 120k exams." "" "Database"
            }
		}
		archifySystem = softwareSystem "ARCHIFY AI Certification Systems" {
            aptitudeGradingAdapter = container "Aptitude Autograding Adapter" "Aptitude Autograding Adapter, parses exams from ungraded exams database" "Aptitude Adapter"
            aptitudePromtOrchestrator = container "Aptitude Prompt Orchestrator" "Aptitude Autograding Prompt Orchestrator" "Prompt Orchestrator"
            aptitudeVectorDb = container "Aptitude Q&A \n Vector Database" "Aptitude Q&A Vector Database with Q&A tuples" "" "Aptitude Q&A Vector Database"

            archifyArchGrading = container "Archify Architecture Exam Grading" {
                archGradingAdapter = component "Architecture Autograding Adapter"
                archPromtOrchestrator = component "Architecture Prompt Orchestrator" 
            }

            dataPipeline = container "Context Data Pre-Processing" {
                knowledgeVectorDb = component "Knowledge Vector DB"
            }

            llmContainer = container "LLM Model" {
                archGuardrails = component "Architecture Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Architecture Guardrails"
                llmModel = component "LLM Model"
            }
		}

		llm = softwareSystem "LLM Model" {
            aptitudeGuardrails = container "Aptitude Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Aptitude Guardrails"
            
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

        archSubmissionService -> archSubmissionUngradedDatabase "Writes submissions to architecture exam"
        

		// Data Pipeline
		aptitudeGradedDatabase -> updater "Reads new graded Q&A tuples from the database via high watermark (timestamp column)"
		updater -> aptitudeVectorDb "Embedds the new Q&A tuples into vector space and writes them to Aptitude Q&A Vector Database"
        updater -> knowledgeVectorDb "Embedds knowledge base into vector space and writes them to Knowledge Vector Database"

		// New LLM aptitude grading System
		aptitudeUngradedDatabase -> aptitudeGradingAdapter "reads ungraded aptitude test exams"
		aptitudeGradingAdapter -> aptitudePromtOrchestrator "Provides Q&A tuple"
		aptitudeGradingAdapter -> aptitudeGradedDatabase "Writes graded Q&A tuples with feedback"
		aptitudePromtOrchestrator -> aptitudeGradingAdapter "Returns LLM grading"
		aptitudePromtOrchestrator -> aptitudeGuardrails "Forwards prompt to be checked"
		aptitudeGuardrails -> aptitudePromtOrchestrator "Compares against expected output format and checks for schema compatibility"
		aptitudeVectorDb -> aptitudePromtOrchestrator "Enriches prompt by providing most similar Q&A tuples"
		llmodel -> aptitudeGuardrails "Returns generated output by LLM"
		aptitudeGuardrails -> llmodel "Analyses for input injection attacks"

        // Architecture Container Relationships
        dataPipeline -> archifyArchGrading "Provide context data"
        archifyArchGrading -> llmodel "Promt to grade exams"
        llmodel -> archifyArchGrading "Return output with graded submission and feedback"
        archifyArchGrading -> certifiableArchGrading "Write automatically graded submission and feedback"
        certifiableArchGrading -> archifyArchGrading "Read ungraded submission for automatic grading"
        certifiableArchGrading -> dataPipeline "Knowledge"

        // Architecture Grading Component Relationships
        archSubmissionUngradedDatabase -> archGradingAdapter "reads ungraded architecture exams"
        archGradingAdapter -> archPromtOrchestrator "provides ungraded architecture exam"
        archGradingAdapter -> archSubmissionGradedDatabase "Writes graded exam with feedback"
        archPromtOrchestrator -> archGradingAdapter "Returns LLM grading"
		archPromtOrchestrator -> archGuardrails "Forwards prompt to be checked"
		archGuardrails -> archPromtOrchestrator "Compares against expected output format and checks for schema compatibility"
		knowledgeVectorDb -> archPromtOrchestrator "Enriches promt by providing most relevant technical context"
		llmModel -> archGuardrails "Returns generated output by LLM"
		archGuardrails -> llmModel "Analyses for input injection attacks"
    }

    views {
        systemContext certifiableSystem {
            include * engineer
			autoLayout
        }
        container archifySystem "Aptitude-Grading" {
            include updater \
                    aptitudeTestTaker \
                    aptitudeManualCapture \
                    aptitudeAutoGrader \
                    aptitudeUngradedDatabase \
                    aptitudeGradedDatabase \
                    aptitudeGradingAdapter \
                    aptitudePromtOrchestrator \
                    aptitudeVectorDb \
                    aptitudeGuardrails \
                    llmodel 
            description "Container diagram for the existing components interacting with the ARCHIFY extensions"
            autoLayout
        }
        container archifySystem "Container-Architecture-Grading" {
            include certifiableArchGrading \
                    dataPipeline \
                    archifyArchGrading \
                    llm
            description "Container diagram for Automated Architecture Grading"
            autoLayout lr 500 750
        }
        component archifyArchGrading "Component-Architecture-Grading" {
            include archGradingAdapter \
                    archPromtOrchestrator \
                    knowledgeVectorDb \
                    archGuardrails \
                    llmModel \
                    archSubmissionService \
                    archManualGrader \
                    archCaseStudyDatabase \
                    archSubmissionUngradedDatabase \
                    archSubmissionGradedDatabase
            description "Component diagram for Automated Architecture Grading"
            autoLayout lr 500 750
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
