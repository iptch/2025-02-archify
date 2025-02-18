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

            certifiableKnowledgeBase = container "Certifiable, Inc. Architecture Knowledge Catalog" {
                certifiableKnowledgeAdapter = component "Knowledge Adapter"
            }
		}
		archifySystem = softwareSystem "ARCHIFY AI Certification Systems" {

            archifyAptGrading = container "ARCHIFY Aptitude Exam Grading" {
                aptitudeGradingAdapter = component "Aptitude Autograding Adapter" "Aptitude Autograding Adapter, parses exams from ungraded exams database" "Aptitude Adapter"
                aptitudePromptOrchestrator = component "Aptitude Prompt Orchestrator" "Aptitude Autograding Prompt Orchestrator" "Prompt Orchestrator"
                
                aptitudeGuardrails = component "Aptitude Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Aptitude Guardrails"
            }

            archifyArchGrading = container "ARCHIFY Architecture Exam Grading" {
                archGradingAdapter = component "Architecture Autograding Adapter"
                archPromptOrchestrator = component "Architecture Prompt Orchestrator" 
                archGuardrails = component "Architecture Guardrails Component" "Guardrails to prevet jailbreaks and increase output consistency" "Architecture Guardrails"
            }

            archifyExamMaintenance = container "ARCHIFY Exam Maintenance" {
                archifyExamMaintenanceAdapter = component "Exam Maintenance Adapter"
                archifyAptQuestionPromptOrchestrator = component "Aptitude Question Prompt Orchestrator"
                archifyAptQuestionGuardRails = component "Aptitude Question Guard Rails"

                archifyArchCaseStudyGenerator = component "Case Study Adapter"
            }
		}

		dataPipelineSystem = softwareSystem "ARCHIFY Data Pipeline" {

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
		certifiableAptGradedDb -> aptAnswersUpdater "provides new Q&A solution tuples via high watermark (timestamp column)"
		aptAnswersUpdater -> aptAnswersVectorDb "embedds the new Q&A tuples into vector space and writes them to Aptitude Q&A Vector Database"
        certifiableKnowledgeAdapter -> knowledgeUpdater "obtains relevant context from document database"
        certifiableArchGrading -> certifiableKnowledgeAdapter "updates catalog"
        knowledgeUpdater -> knowledgeVectorDb "embedds knowledge base into vector space and writes them to Knowledge Vector Database"

        // Aptitude Grading
        // Aptitude Container Relationships
        dataPipelineAptAnswers -> archifyAptGrading "updates vector database with new Q&A tuples"
        archifyAptGrading -> llmSystem "sends prompt"
        llmSystem -> archifyAptGrading "returns graded submission and extensive feedback"
        archifyAptGrading -> certifiableAptGrading "write auto-graded submission to database"
        certifiableAptGrading -> archifyAptGrading "reads ungraded submission"

        // Aptitude Component Relationships
		certifiableUngradedAptDb -> aptitudeGradingAdapter "reads ungraded aptitude test exams"
		aptitudeGradingAdapter -> aptitudePromptOrchestrator "Provides Q&A tuple"
		aptitudeGradingAdapter -> certifiableAptGradedDb "writes graded Q&A tuples with feedback"
		aptitudePromptOrchestrator -> aptitudeGradingAdapter "returns LLM grading"
		aptitudePromptOrchestrator -> aptitudeGuardrails "forwards prompt to be checked"
		aptitudeGuardrails -> aptitudePromptOrchestrator "compares against expected output format and checks for schema compatibility"
		aptAnswersVectorDb -> aptitudePromptOrchestrator "enriches prompt by providing most similar Q&A tuples"
		llmSystem -> aptitudeGuardrails "returns generated output by LLM"
		aptitudeGuardrails -> llmSystem "analyses for input injection attacks"

        // Architecture Grading
        // Architecture Container Relationships
        dataPipelineKnowledge -> archifyArchGrading "provides relevant technical context for grading"
        archifyArchGrading -> llmSystem "sends prompt"
        llmSystem -> archifyArchGrading "returns extensive feedback and proposes grading"
        archifyArchGrading -> certifiableArchGrading "write feedback and AI grade proposal"
        certifiableArchGrading -> archifyArchGrading "read ungraded submissions"

        // Architecture Grading Component Relationships
        certifiableArchUngradedDb -> archGradingAdapter "reads ungraded architecture exams"
        archGradingAdapter -> archPromptOrchestrator "provides ungraded architecture exam"
        archGradingAdapter -> certifiableArchGradedDb "Writes graded exam with feedback"
        archPromptOrchestrator -> archGradingAdapter "returns LLM grading"
		archPromptOrchestrator -> archGuardrails "sanitize input and forward prompt"
		archGuardrails -> archPromptOrchestrator "enforce output format and filter harmful content"
		knowledgeVectorDb -> archPromptOrchestrator "identify relevant technical areas for given case study and evaluation criteria"
        llmSystem -> archGuardrails "returns generated output by LLM"
		archGuardrails -> llmSystem "analyses for input injection attacks"
        certifiableArchManualGrader -> certifiableArchGradedDb "reads AI Graded Exams"
        certifiableArchManualGrader -> certifiableArchGradedDb "writes manually reviews final Graded Exams"


        // Exam Generator
        // Question Generator Container Relationships
        certifiableAptGrading -> archifyExamMaintenance "read existing aptitude questions"
        certifiableArchGrading -> archifyExamMaintenance "read existing case studies"
        
        archifyExamMaintenance -> llmSystem "prompt to generate questions and case studies"
        archifyExamMaintenance -> certifiableAptGrading "write generated aptitude questions"
        archifyExamMaintenance -> certifiableArchGrading "write generated case studies"

        // Question Generator Container Relationships
        certifiableKnowledgeBase -> archifyAptQuestionPromptOrchestrator "read plain text knowledge to enrich prompt"        
        knowledgeVectorDb -> archifyAptQuestionPromptOrchestrator "read data to correlate knowledge with questions"
        aptAnswersVectorDb -> archifyAptQuestionPromptOrchestrator "read known answers and questions"
        archifyExamMaintenanceAdapter -> archifyAptQuestionPromptOrchestrator "request new exam creation based on scheduled jobs"
        archifyAptQuestionPromptOrchestrator -> archifyExamMaintenanceAdapter "return generated exam exam questions and case studies"
    
        archifyAptQuestionPromptOrchestrator -> archifyAptQuestionGuardRails "enrich prompt with technical context and instructions to generate exam questions and case studies."
        archifyAptQuestionGuardRails -> archifyAptQuestionPromptOrchestrator "return generated exam exam questions and case studies"
        archifyAptQuestionGuardRails -> llmSystem "prompt LLM"
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
            title "[Container] ARCHIFY Aptitude Exams"
            description "Overview of automated aptitude exam grading"
        }
        container archifySystem "Container-Architecture-Grading" {
            include certifiableArchGrading \
                    dataPipelineKnowledge \
                    archifyArchGrading \
                    llmSystem \
                    certifiableKnowledgeBase
            title "[Container] ARCHIFY Architecture Exams"
            description "Overview of automated architecture case study grading"
        }
        container archifySystem "Container-Exam-Maintenance" {
            include certifiableAptGrading \
                    certifiableArchGrading \
                    dataPipelineKnowledge \
                    archifyExamMaintenance
            title "[Container] ARCHIFY Exam Maintenance"
            description "Overview of automated exam maintenance"
        }
        component archifyAptGrading "Component-Aptitude-Grading" {
            include aptAnswersUpdater \
                    certifiableestTaker \
                    certifiableAptManualCapture \
                    certifiableAutoGrader \
                    certifiableUngradedAptDb \
                    certifiableAptGradedDb \
                    aptitudeGradingAdapter \
                    aptitudePromptOrchestrator \
                    aptAnswersVectorDb \
                    aptitudeGuardrails \
                    llmSystem 
            title "[Component] ARCHIFY Aptitude Exams"
            description "Detailled view of components interacting to achieve automated aptitude exam grading"                    
        }
        component archifyArchGrading "Component-Architecture-Grading" {
            include archGradingAdapter \
                    archPromptOrchestrator \
                    knowledgeVectorDb \
                    archGuardrails \
                    llmSystem \
                    certfifiableArchSubmissionService \
                    certifiableArchManualGrader \
                    certifiableArchUngradedDb \
                    certifiableArchGradedDb \
                    certifiableKnowledgeAdapter \
                    knowledgeUpdater
            title "[Component] ARCHIFY Architecture Exams"
            description "Detailled view of components interacting to achieve automated architecture case study grading"     
        }
        component archifyArchGrading "Component-Exam-Maintenance" {
            include certifiableAptQuestionsDb \
                    archifyExamMaintenanceAdapter \
                    knowledgeVectorDb \
                    aptAnswersVectorDb \
                    llmSystem \
                    archifyAptQuestionPromptOrchestrator \
                    archifyAptQuestionGuardRails \
                    certifiableCaseStudyDb \
                    certifiableKnowledgeBase
            title "[Component] ARCHIFY Exam Maintenance"
            description "Detailled view of components interacting for automated exam maintenance"                         
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
