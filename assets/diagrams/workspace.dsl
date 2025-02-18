workspace {
    model {
        candidate = person "Certification Candidate" "A candidate that is aiming to get professionally certified by Cerfifiable Inc.." "Candidate"
        expert = person "IT Expert" "IT Expert Grader, working for Certifiable Inc., grading exams and maintaining exam question catalog" "Expert"
		engineer = person "ML Engineer" "AI Engineer, working for Certifiable Inc., maintaining LLM system components" "ML Engineer"
		
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

		dataPipelineSystem = softwareSystem "ARCHIFY \n Data Pipeline" {

            dataPipelineAptAnswers = container "Aptitude Q&A Data Pipeline" {
                aptAnswersUpdater = component "Aptitude Data Updater" "Updates the Vector DB periodically with new Q&A tuples" "Data Pipeline"
                aptAnswersVectorDb = component "Aptitude Q&A \n Vector Database" "Aptitude Q&A Vector Database with Q&A tuples" "" "Aptitude Q&A Vector Database"
            }

            dataPipelineKnowledge = container "Knowledge Base Data Pipeline" {
                knowledgeUpdater = component "Knowledge Data Updater"
                knowledgeVectorDb = component "Knowledge Vector DB" "" "" "Database"
            }			
		}

		llmSystem = softwareSystem "LLM Model" 

		// People and Software Systems
		candidate -> certifiableSystem "takes aptitude exam (multi-choice and short-answer test)"
        expert -> certifiableSystem "grades short-answer tests, provides exam feedback, updates question catalog"
		engineer -> archifySystem "maintains and monitors LLM system components (including parameter and threshold tuning)"
		archifySystem -> certifiableSystem "reads ungraded exam database, grades exams"
        archifySystem -> llmSystem "prompt LLM for grading, feedback and new test generation"
        llmSystem -> archifySystem "return LLM result"

		// Existing Certifiable System
		certifiableestTaker -> certifiableAptManualCapture "passes short-answer questions"
		certifiableestTaker -> certifiableAutoGrader "passes multiple-choice questions to auto-grader"
		certifiableAutoGrader -> certifiableAptGradedDb "writes multiple-choice question answers and results"
		certifiableAptManualCapture -> certifiableUngradedAptDb "forwards ungraded Q&A tuples"
        certfifiableArchSubmissionService -> certifiableArchUngradedDb "writes submissions to architecture exam"
        
		// Data Pipeline
		certifiableAptGradedDb -> aptAnswersUpdater "provides newly graded Q&A tuples via high watermark (timestamp column)"
		aptAnswersUpdater -> aptAnswersVectorDb "embedds the new Q&A tuples into vector space and writes them to Aptitude Q&A Vector Database"
        certifiableKnowledgeAdapter -> knowledgeUpdater "reads information from knowledge base"
        knowledgeUpdater -> knowledgeVectorDb "embedds knowledge base into vector space and writes them to Knowledge Vector Database"

        // Aptitude Grading
        // Aptitude Container Relationships
        dataPipelineAptAnswers -> archifyAptGrading "updates vector database with new Q&A tuples"
        archifyAptGrading -> llmSystem "promt to grade exams"
        llmSystem -> archifyAptGrading "return output with graded submission and feedback"
        archifyAptGrading -> certifiableAptGrading "write automatically graded submission and feedback"
        certifiableAptGrading -> archifyAptGrading "reads ungraded submission"
        certifiableAptGrading -> dataPipelineAptAnswers "write allowed Questions and Answers from past exams"

        // Aptitude Component Relationships
		certifiableUngradedAptDb -> aptitudeGradingAdapter "reads ungraded aptitude test exams"
		aptitudeGradingAdapter -> aptitudePromtOrchestrator "Provides Q&A tuple"
		aptitudeGradingAdapter -> certifiableAptGradedDb "writes graded Q&A tuples with feedback"
		aptitudePromtOrchestrator -> aptitudeGradingAdapter "returns LLM grading"
		aptitudePromtOrchestrator -> aptitudeGuardrails "forwards prompt to be checked"
		aptitudeGuardrails -> aptitudePromtOrchestrator "compares against expected output format and checks for schema compatibility"
		aptAnswersVectorDb -> aptitudePromtOrchestrator "enriches prompt by providing most similar Q&A tuples"
		llmSystem -> aptitudeGuardrails "returns generated output by LLM"
		aptitudeGuardrails -> llmSystem "analyses for input injection attacks"

        // Architecture Grading
        // Architecture Container Relationships
        certifiableKnowledgeBase -> dataPipelineKnowledge "Pre-Process technical knowhow database for querying"
        dataPipelineKnowledge -> archifyArchGrading "Identify relevant technical context"
        archifyArchGrading -> llmSystem "promt to grade exams"
        llmSystem -> archifyArchGrading "return output with graded submission and feedback"
        archifyArchGrading -> certifiableArchGrading "write automatically graded submission and feedback"
        certifiableArchGrading -> archifyArchGrading "read ungraded submission for automatic grading"

        // Architecture Grading Component Relationships
        certifiableArchUngradedDb -> archGradingAdapter "reads ungraded architecture exams"
        archGradingAdapter -> archPromtOrchestrator "provides ungraded architecture exam"
        archGradingAdapter -> certifiableArchGradedDb "Writes graded exam with feedback"
        archPromtOrchestrator -> archGradingAdapter "returns LLM grading"
		archPromtOrchestrator -> archGuardrails "sanitize input and forward promt"
		archGuardrails -> archPromtOrchestrator "enforce output format and filter harmful content"
		knowledgeVectorDb -> archPromtOrchestrator "identify relevant technical areas for given case study and evaluation criteria"
		certifiableKnowledgeAdapter -> archPromtOrchestrator "read technical knowledge (plain text= to enrich promt with technical context"
        llmSystem -> archGuardrails "returns generated output by LLM"
		archGuardrails -> llmSystem "analyses for input injection attacks"
        certifiableArchManualGrader -> certifiableArchGradedDb "reads AI Graded Exams"
        certifiableArchManualGrader -> certifiableArchGradedDb "writes manually reviews final Graded Exams"


        // Exam Generator
        // Question Generator Container Relationships
        certifiableAptGrading -> archifyExamMaintenance "read existing aptitude questions"
        certifiableArchGrading -> archifyExamMaintenance "read existing case studies"
        
        archifyExamMaintenance -> llmSystem "promt to generate questions and case studies"
        archifyExamMaintenance -> certifiableAptGrading "write generated aptitude questions"
        archifyExamMaintenance -> certifiableArchGrading "write generated case studies"

        // Question Generator Container Relationships
        certifiableKnowledgeBase -> archifyAptQuestionPromtOrchestrator "read plain text knowledge to enrich promt"        
        knowledgeVectorDb -> archifyAptQuestionPromtOrchestrator "read data to correlate knowledge with questions"
        aptAnswersVectorDb -> archifyAptQuestionPromtOrchestrator "read known answers and questions"
        archifyExamMaintenanceAdapter -> archifyAptQuestionPromtOrchestrator "request new exam creation based on scheduled jobs"
        archifyAptQuestionPromtOrchestrator -> archifyExamMaintenanceAdapter "return generated exam exam questions and case studies"
    
        archifyAptQuestionPromtOrchestrator -> archifyAptQuestionGuardRails "enrich promt with technical context and instructions to generate exam questions and case studies."
        archifyAptQuestionGuardRails -> archifyAptQuestionPromtOrchestrator "return generated exam exam questions and case studies"
        archifyAptQuestionGuardRails -> llmSystem "promt LLM"
        llmSystem -> archifyAptQuestionGuardRails "filter output for harmful content and enforce needed output data structure"
        archifyExamMaintenanceAdapter -> certifiableAptQuestionsDb "write generated exam questions and flag outdated questions"
        archifyExamMaintenanceAdapter -> certifiableCaseStudyDb "write generated case studies"
        certifiableCaseStudyDb -> archifyArchCaseStudyGenerator "read existing case studies"
        
    }

    views {
        systemContext certifiableSystem {
            include * engineer llmSystem
            title "[System Context] Certifiable Inc."
            description "Integration between the existing Certifiable System and new ARCHIFY AI System"
        }
        container archifySystem "Container-Aptitude-Grading" {
            include certifiableAptGrading \
                    dataPipelineAptAnswers \
                    archifyAptGrading \
                    llmSystem
            description "Container diagram for Automated Aptitude Grading"
        }
        container archifySystem "Container-Architecture-Grading" {
            include certifiableArchGrading \
                    dataPipelineKnowledge \
                    archifyArchGrading \
                    llmSystem \
                    certifiableKnowledgeBase
            description "Container diagram for Automated Architecture Grading"
        }
        container archifySystem "Container-Exam-Maintenance" {
            include certifiableAptGrading \
                    certifiableArchGrading \
                    dataPipelineKnowledge \
                    archifyExamMaintenance
            description "Container diagram for Automated Architecture Grading"
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
