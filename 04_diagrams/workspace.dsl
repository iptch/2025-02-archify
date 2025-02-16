//TODO: Color the legacy/existing components that are integrated 1:1 in gray
workspace {
    model {
        candidate = person "Certification Candidate" "A candidate that is aiming to get professionally certified by Cerfifiable Inc.." "Candidate"
        expert = person "IT Expert" "IT Expert Grader, working for Certifiable Inc." "Expert"
		engineer = person "ML Engineer" "AI Engineer, working for Certifiable Inc." "ML Engineer"
		
		certifiableSystem = softwareSystem "Certifiable Inc. Existing Software System" {

            certifiableAptGrading = container "Certifiable Aptitude Grading Module" {
                certifiableestTaker = component "Aptitude Test Taker" "Interface handling test loading, question sending, answer capturing and test timing" "Aptitude Test Taker"
                certifiableAutoGrader = component "Aptitude Auto Grader" "Auto-grading component for multiple-choice questions" "Auto Grader"
                certifiableAptManualCapture = component "Aptitude Manuel Capture" "Manual capture component for short-answer questions" "Manual Capture"
                certifiableUngradedAptDb = component "Ungraded Database" "Contains the ungraded short-answer Q&A tuples" "" "Database"
                certifiableAptGradedDb = component "Graded Database" "Graded Exams Database, contains the aptitutde tests from previous 120k exams." "" "Database"
                certifiableAptQuestionsDb = component "Aptitude Test Database" "" "" "Database"
            }

            certifiableArchGrading = container "Certifiable Architecture Exams Module" {
                certfifiableArchSubmissionService = component "Architecture Submission Service" "" "Architecture Manual Grader"
                certifiableArchManualGrader = component "Architecture Manual Grader" "" "Architecture Manual Grader"
                certifiableCaseStudyDb = component "Case Study Database" "Database, contains case studies." "" "Database"
                certifiableArchUngradedDb = component "Submission Ungraded Database" "Ungraded Exams Database, contains the architecture submissions from previous 120k exams." "" "Database"
                certifiableArchGradedDb = component "Submission Graded Database" "Graded Exams & Feedback Database, contains the graded architecture submissions and feedback from previous 120k exams." "" "Database"
            }

            certifiableKnowledgeBase = container "Certifiable Knowledge Base" {
                certifiableKnowledgeAdapter = component "Knowledge Adapter"
            }
		}
		archifySystem = softwareSystem "ARCHIFY AI Certification Systems" {

            archifyAptGrading = container "Archify Aptitude Exam Grading" {
                aptitudeGradingAdapter = component "Aptitude Autograding Adapter" "Aptitude Autograding Adapter, parses exams from ungraded exams database" "Aptitude Adapter"
                aptitudePromtOrchestrator = component "Aptitude Prompt Orchestrator" "Aptitude Autograding Prompt Orchestrator" "Prompt Orchestrator"
                
                aptitudeGuardrails = component "Aptitude Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Aptitude Guardrails"
            }

            archifyArchGrading = container "Archify Architecture Exam Grading" {
                archGradingAdapter = component "Architecture Autograding Adapter"
                archPromtOrchestrator = component "Architecture Prompt Orchestrator" 
                archGuardrails = component "Architecture Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Architecture Guardrails"
            }

            archifyExamMaintenance = container "Archify Exam Maintenance" {
                archifyExamMaintenanceAdapter = component "Exam Maintenance Adapter"
                archifyAptQuestionPromtOrchestrator = component "Aptitude Question Promt Orchestrator"
                archifyAptQuestionGuardRails = component "Aptitude Question Guard Rails"

                archifyArchCaseStudyGenerator = component "Case Study Adapter"
            }
		}

		dataPipelineSystem = softwareSystem "Context Data Pre-Processing" {

            dataPipelineAptAnswers = container "Aptitude Integration" {
                aptAnswersUpdater = component "Aptitude Data Pipeline" "Updates the Vector DB periodically with new Q&A tuples" "Data Pipeline"
                aptAnswersVectorDb = component "Aptitude Q&A \n Vector Database" "Aptitude Q&A Vector Database with Q&A tuples" "" "Aptitude Q&A Vector Database"
            }

            dataPipelineKnowledge = container "Knowledge Base" {
                knowledgeUpdater = component "Knowledge Data Pipeline"
                knowledgeVectorDb = component "Knowledge Vector DB" "" "" "Database"
            }			
		}

		llmSystem = softwareSystem "LLM Model" 

		// People and Software Systems
		candidate -> certifiableSystem "Takes aptitude certification exam, consisting of multiple-choice and short-answer tests"
        expert -> certifiableSystem "Grades short-answer tests, provides feedback. Analyses question catalog."
		engineer -> archifySystem "Maintains LLM components used for auto-grading, including monitoring, parameter and threshold tuning, updating models etc."
		archifySystem -> certifiableSystem "Provides databases with ungraded exam questions and graded exam database"
        archifySystem -> llmSystem "Prompt LLM for grading, test generation and feedback generation"
        llmSystem -> archifySystem "Return returns grading results, test generation and feedback generation"

		// Existing Certifiable System
		certifiableestTaker -> certifiableAptManualCapture "Passes short-answer questions"
		certifiableestTaker -> certifiableAutoGrader "Passes multiple-choice questions to auto-grader"
		certifiableAutoGrader -> certifiableAptGradedDb "Writes multiple-choice question answers and results"
		certifiableAptManualCapture -> certifiableUngradedAptDb "Forwards ungraded Q&A tuples"
        certfifiableArchSubmissionService -> certifiableArchUngradedDb "Writes submissions to architecture exam"
        
		// Data Pipeline
		certifiableAptGradedDb -> aptAnswersUpdater "Reads new graded Q&A tuples from the database via high watermark (timestamp column)"
		aptAnswersUpdater -> aptAnswersVectorDb "Embedds the new Q&A tuples into vector space and writes them to Aptitude Q&A Vector Database"
        certifiableKnowledgeAdapter -> knowledgeUpdater "Reads information from knowledge base"
        knowledgeUpdater -> knowledgeVectorDb "Embedds knowledge base into vector space and writes them to Knowledge Vector Database"

        // Aptitude Grading
        // Aptitude Container Relationships
        dataPipelineAptAnswers -> archifyAptGrading "Provide context data"
        archifyAptGrading -> llmSystem "Promt to grade exams"
        llmSystem -> archifyAptGrading "Return output with graded submission and feedback"
        archifyAptGrading -> certifiableAptGrading "Write automatically graded submission and feedback"
        certifiableAptGrading -> archifyAptGrading "Read ungraded submission for automatic grading"
        certifiableAptGrading -> dataPipelineAptAnswers "Allowed Answers and Answers from past exams"

        // Aptitude Component Relationships
		certifiableUngradedAptDb -> aptitudeGradingAdapter "reads ungraded aptitude test exams"
		aptitudeGradingAdapter -> aptitudePromtOrchestrator "Provides Q&A tuple"
		aptitudeGradingAdapter -> certifiableAptGradedDb "Writes graded Q&A tuples with feedback"
		aptitudePromtOrchestrator -> aptitudeGradingAdapter "Returns LLM grading"
		aptitudePromtOrchestrator -> aptitudeGuardrails "Forwards prompt to be checked"
		aptitudeGuardrails -> aptitudePromtOrchestrator "Compares against expected output format and checks for schema compatibility"
		aptAnswersVectorDb -> aptitudePromtOrchestrator "Enriches prompt by providing most similar Q&A tuples"
		llmSystem -> aptitudeGuardrails "Returns generated output by LLM"
		aptitudeGuardrails -> llmSystem "Analyses for input injection attacks"

        // Architecture Grading
        // Architecture Container Relationships
        dataPipelineKnowledge -> archifyArchGrading "Provide context data"
        archifyArchGrading -> llmSystem "Promt to grade exams"
        llmSystem -> archifyArchGrading "Return output with graded submission and feedback"
        archifyArchGrading -> certifiableArchGrading "Write automatically graded submission and feedback"
        certifiableArchGrading -> archifyArchGrading "Read ungraded submission for automatic grading"
        certifiableArchGrading -> dataPipelineKnowledge "Knowledge"

        // Architecture Grading Component Relationships
        certifiableArchUngradedDb -> archGradingAdapter "reads ungraded architecture exams"
        archGradingAdapter -> archPromtOrchestrator "provides ungraded architecture exam"
        archGradingAdapter -> certifiableArchGradedDb "Writes graded exam with feedback"
        archPromtOrchestrator -> archGradingAdapter "Returns LLM grading"
		archPromtOrchestrator -> archGuardrails "Forwards prompt to be checked"
		archGuardrails -> archPromtOrchestrator "Compares against expected output format and checks for schema compatibility"
		knowledgeVectorDb -> archPromtOrchestrator "Enriches promt by providing most relevant technical context"
		llmSystem -> archGuardrails "Returns generated output by LLM"
		archGuardrails -> llmSystem "Analyses for input injection attacks"
        certifiableArchManualGrader -> certifiableArchGradedDb "Reads AI Graded Exams"
        certifiableArchManualGrader -> certifiableArchGradedDb "Writes manually reviews final Graded Exams"

        // Exam Generator
        // Question Generator Container Relationships
        certifiableAptGrading -> archifyExamMaintenance "Read existing aptitude questions"
        certifiableArchGrading -> archifyExamMaintenance "Read existing case studies"
        
        archifyExamMaintenance -> llmSystem "Promt to generate questions and case studies"
        archifyExamMaintenance -> certifiableAptGrading "Write generated aptitude questions"
        archifyExamMaintenance -> certifiableArchGrading "Write generated case studies"

        // Question Generator Container Relationships
        knowledgeVectorDb -> archifyAptQuestionPromtOrchestrator "Read knowhow to give technical context for generated questions"
        aptAnswersVectorDb -> archifyAptQuestionPromtOrchestrator "Read known answers and questions"
        certifiableKnowledgeBase -> archifyExamMaintenanceAdapter "Read latest entries to identify new areas"
        archifyExamMaintenanceAdapter -> archifyAptQuestionPromtOrchestrator "Provide identified areas where new questions are needed"
        archifyAptQuestionPromtOrchestrator -> archifyExamMaintenanceAdapter "Return generated exam exam questions and case studies"
        archifyAptQuestionPromtOrchestrator -> archifyAptQuestionGuardRails "Enrich promt with technical context. Identify additional ares for questions by finding which specifics have little similarity in existing answers."
        archifyAptQuestionGuardRails -> archifyAptQuestionPromtOrchestrator "Return generated exam exam questions and case studies"
        archifyAptQuestionGuardRails -> llmSystem "Promt LLM"
        llmSystem -> archifyAptQuestionGuardRails "Filter output for harmful content and enforce needed structures"
        archifyExamMaintenanceAdapter -> certifiableAptQuestionsDb "Write generated exam questions"
        archifyExamMaintenanceAdapter -> certifiableCaseStudyDb "Write generated case studies"
        certifiableCaseStudyDb -> archifyArchCaseStudyGenerator "Read existing case studies"
        
    }

    views {
        systemContext certifiableSystem {
            include * engineer llmSystem
			autoLayout
        }
        container archifySystem "Container-Aptitude-Grading" {
            include certifiableAptGrading \
                    dataPipelineAptAnswers \
                    archifyAptGrading \
                    llmSystem
            description "Container diagram for Automated Aptitude Grading"
            autoLayout lr 500 750
        }
        container archifySystem "Container-Architecture-Grading" {
            include certifiableArchGrading \
                    dataPipelineKnowledge \
                    archifyArchGrading \
                    llmSystem
            description "Container diagram for Automated Architecture Grading"
            autoLayout lr 500 750
        }
        container archifySystem "Container-Exam-Maintenance" {
            include certifiableAptGrading \
                    certifiableArchGrading \
                    dataPipelineKnowledge \
                    archifyExamMaintenance
            description "Container diagram for Automated Architecture Grading"
            autoLayout lr 500 750
        }
        component archifyAptGrading "Component-Aptitude-Grading" {
            include aptAnswersUpdater \
                    certifiableestTaker \
                    certifiableAptManualCapture \
                    certifiableAutoGrader \
                    certifiableUngradedAptDb \
                    certifiableAptGradedDb \
                    aptitudeGradingAdapter \
                    aptitudePromtOrchestrator \
                    aptAnswersVectorDb \
                    aptitudeGuardrails \
                    llmSystem 
            description "Container diagram for the existing components interacting with the ARCHIFY extensions"
            autoLayout lr 500 750
        }
        component archifyArchGrading "Component-Architecture-Grading" {
            include archGradingAdapter \
                    archPromtOrchestrator \
                    knowledgeVectorDb \
                    archGuardrails \
                    llmSystem \
                    certfifiableArchSubmissionService \
                    certifiableArchManualGrader \
                    certifiableArchUngradedDb \
                    certifiableArchGradedDb \
                    certifiableKnowledgeAdapter \
                    knowledgeUpdater
            description "Component diagram for Automated Architecture Grading"
            autoLayout lr 500 750
        }
        component archifyArchGrading "Component-Exam-Maintenance" {
            include certifiableAptQuestionsDb \
                    archifyExamMaintenanceAdapter \
                    knowledgeVectorDb \
                    aptAnswersVectorDb \
                    llmSystem \
                    archifyAptQuestionPromtOrchestrator \
                    archifyAptQuestionGuardRails \
                    certifiableCaseStudyDb \
                    certifiableKnowledgeBase
            description "Component diagram for Exam Maintenance"
            autoLayout lr 750 500
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
