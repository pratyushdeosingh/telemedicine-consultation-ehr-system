# Final submission: Person 1 checklist and recording plan

Prepared from the final DBMS assignment instructions dated 26 October 2026 and the local project files. This plan is preparation, not evidence that the hosted application or database is currently healthy.

Confirmed: Person 1 is Pratyush; record the deployed website at https://telemedicine-consultation-ehr-syste.vercel.app/ . Report and slides are handled by teammates. Sign in before capturing the application segment and verify both connection indicators. Do not use frontend fallback/sample-only screens as database evidence.

## Faculty requirements

- One submission Word document containing semester, course, faculty, project title, team names/register numbers, GitHub link, YouTube link, and base paper or principal technical references.
- Technical report in the supplied template; repository example includes a PDF report.
- 5-8 presentation slides.
- Accessible GitHub repository with application source, executable SQL, setup instructions, ER diagram, schema, normalization evidence, synthetic sample data, screenshots, tests and results.
- Working database-connected application with at least five meaningful end-to-end features, validation, and database query evidence.
- A 3-5 minute YouTube video, Unlisted or Public. Every member must be shown. Put its link in both README and submission document.
- Deadline and any later faculty instructions need confirmation. Older DA2/DA3 notes do not override this final brief.

## Person 1: repository work

Existing remote: https://github.com/pratyushdeosingh/telemedicine-consultation-ehr-system

Keep the working backend/frontend arrangement. The brief's directory tree is an example; do not rename source folders merely to match it.

Recommended final layout:

```text
README.md                         Person 3 finalizes
backend/                          API, scripts, tests
frontend/                         React application
api/                              Vercel API entry
database/                         Oracle schema, seeds and SQL queries
cassandra/                        Cassandra schema, seeds and CQL
deploy/                           Environment/deployment instructions
docs/
  design/                         Final ER diagram, relational schema, 3NF evidence
  screenshots/                    Application AND database result evidence
  testing/                        Dated expected/actual results and test output
report/DBMS_Project_Report.pdf     Person 2 provides final export
presentation/DBMS_Project_Presentation.pptx
                                  Person 3 provides final deck
```

Current mapping: database/telemedicine_ehr.sql contains the combined schema and base seed; database/academic_seed.sql supplies extended synthetic data; database/queries.sql contains selected SQL. Explain this in database/README.md instead of copying or renaming scripts with dependencies. backend/tests already holds automated tests.

Work remaining:

- [ ] Integrate the final DA1 ER diagram, relational schema, functional dependencies and normalization evidence. The workspace has a DA1 ER image, but review it against the implemented schema before using it as final evidence.
- [ ] Add final report/deck supplied by teammates to the agreed folders. Do not present placeholders as completed deliverables.
- [ ] Capture evidence for five actual workflows and associated database records; current tracked screenshots focus on Cassandra.
- [ ] Record test cases: action, input, expected result, actual result, pass/fail, date and environment. Historical checklist ticks are not a fresh test run.
- [ ] Verify setup from a clean checkout where feasible. Use the documented order; do not rerun schema setup against production merely for a recording.
- [ ] Review tracked files for secrets, wallets, bundles, credentials and private data. Existing .gitignore excludes common env files; that alone does not prove files/history are safe.
- [ ] Give Person 3 final file paths, setup corrections, limitations and video link for README. Include all names/register numbers and a <=150-word abstract.
- [ ] Review final links and commit/push the completed package; check evaluator access to both repository and video.

## Team recording timeline: target 4:40

| Final time | Speaker | Content |
| --- | --- | --- |
| 0:00-1:10 | Sarbajeet | Problem, objective, core Oracle relationships; show a real table result and a short join result |
| 1:10-3:25 | Pratyush | Working application with five connected workflow actions; brief Cassandra extension if time permits |
| 3:25-4:35 | Dhuna | Design choices, validation/transaction evidence, dated test outcomes, limitations and outcome |
| 4:35-4:40 | End card | Project/team/repository reference |

Four minutes plus 30 seconds per member becomes 5:30 and exceeds the brief. Trim each segment to the allocated duration, including transitions. Every speaker should appear on camera, ideally picture-in-picture throughout their segment.

## Pratyush: 2:15 application shot list

Rehearse first. The following is a target sequence, not a claim that these writes have been performed. Use one synthetic patient and one suitable unsettled appointment to connect the story. Prepare valid catalog IDs and field values privately before recording. Never display a password or environment file.

| Segment time | Screen/action | Suggested narration |
| --- | --- | --- |
| 0:00-0:10 | Overview, actual connection indicators | "This is Care Continuum. The React interface uses our Express API to access Oracle, with Cassandra providing an additional patient timeline." |
| 0:10-0:30 | Register synthetic patient; find saved record | "Registration saves the patient in Oracle. The saved identity is then available to the other care workflows." |
| 0:30-0:50 | Book appointment linked to that patient and doctor | "This appointment connects the patient and doctor. A virtual consultation also has a related session record." |
| 0:50-1:15 | Create a valid prescription on that appointment | "The prescription stores a header and medicine items. The database transaction keeps these records together; allergy checks can reject a conflicting item." |
| 1:15-1:40 | Create lab order and enter its result | "The lab order links a catalog test to this appointment, and its result is stored against the order." |
| 1:40-2:00 | Generate invoice; expand item breakdown | "Billing calculates medicine and laboratory charges for the same appointment. The breakdown shows how the total is obtained." |
| 2:00-2:15 | Cassandra timeline, select populated patient/month, refresh if rehearsed | "The timeline groups imported events by patient and month. Refresh from Oracle is a manual import; it is not automatic synchronization." |

The five primary workflow demonstrations are registration, booking, prescription creation, lab order/result recording, and invoice generation. Show successful saved results, not just empty forms. If these actions cannot fit at readable speed, allocate the final 15 seconds to the five primary workflows and cover Cassandra in Dhuna's design explanation. Do not speed up narration until it becomes unintelligible.

For the timeline, newly entered dates and the selected month must agree. A pre-existing populated patient/month is acceptable if clearly identified as a separate example.

## Sarbajeet: database evidence

Have SQL client tabs ready before recording. Show a limited patient/appointment result and a readable join such as Q2 in database/queries.sql. Explain PATIENT -> APPOINTMENT -> PRESCRIPTION/PRESCRIPTION_ITEM, LAB_ORDER/TEST_RESULT and BILLING_INVOICE using the actual keys. Group the 18 Oracle tables by function rather than reading every column.

INSERT/UPDATE/DELETE/SELECT, joins, aggregates, subqueries, views and relevant transaction/index evidence belong in the scripts/report/tests even when the video has room for only selected examples. Use a disposable test record and a controlled rollback for destructive SQL demonstrations.

## Dhuna: design and test evidence

- Explain normalized Oracle relationships, separate repeated values, keys and constraints. Use the reviewed DA1 evidence rather than asserting 3NF without dependencies/decomposition.
- Explain Cassandra's query-oriented patient/month partition and manual refresh; it is an extension to the relational system.
- Show a current test-results summary and one invalid-operation example. State counts only after running and recording the checks.
- For database-trigger proof, submit the conflicting prescription and show the server rejection, then verify no prescription header/items were stored. The website displays an advance warning but does not disable submission for an allergy conflict. The warning alone does not prove the Oracle trigger executed. See PRATYUSH_RECORDING_RUNBOOK.md for the source-checked steps.
- Mention concrete limits: manual Cassandra synchronization; single-node local demonstration does not prove multi-node failover; billing status changes do not transfer money.

## OBS and integration checklist

Suggested team standard: landscape 1920x1080 at 30 fps, matching layout and readable browser zoom. Run OBS Auto-Configuration Wizard for recording, then test performance on the actual laptop. Add the application window/display, microphone, and webcam as sources. Place the webcam where it does not obscure form fields or results.

Make a 15-second trial and watch/listen before the real take. Check text, microphone, camera, framing and notification suppression. Record to MKV and remux to MP4 for editing if needed. OBS documents this workflow at https://obsproject.com/kb/standard-recording-output-guide and https://obsproject.com/kb/quick-start-guide .

Leave a short pause at the start/end for trimming. Name clips 01_Sarbajeet.mp4, 02_Pratyush.mp4 and 03_Dhuna.mp4. Store raw videos outside the Git repository. Assemble in that order, normalize speech volume, trim dead time, add brief name labels and check the full exported duration. Final export target: 4:40, hard maximum 5:00.

Upload to YouTube as Unlisted or Public. Test the link while signed out, verify all faces and readable database evidence, and send the final URL to both README and Word-document owners. Submit the one Word document with working links as required; it is distinct from the technical report PDF in the repository.
