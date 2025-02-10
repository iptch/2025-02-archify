workspace "Archify" "Software system diagram" {

    !identifiers hierarchical

    model {
        u = person "Certification Candidate"
        ss = softwareSystem "ARCHIFY Aptitute Test System" {
            wa = container "Web Application"
            db = container "Database Schema" {
                tags "Database"
            }
        }

        u -> ss.wa "Takes Exam"
        ss.wa -> ss.db "Reads from and writes to"
    }

    views {
        systemContext ss "Diagram1" {
            include *
            autolayout lr
        }

        container ss "Diagram2" {
            include *
            autolayout lr
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                background #e7004c
                shape person
            }
            element "Software System" {
                background #0065a1
            }
            element "Container" {
                background #aecee1
            }
            element "Database" {
                shape cylinder
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}
