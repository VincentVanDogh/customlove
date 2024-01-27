## Introduction
Welcome to our SCRUM Process Wiki! This page serves as a comprehensive guide to the SCRUM framework, a widely adopted agile methodology for managing and delivering software projects. SCRUM emphasizes collaboration, adaptability, and iterative progress, making it an ideal approach for dynamic development environments.

## Roles and Responsibilities
### Product Owner
In the context of our university project, the traditional role of a specific Product Owner may not be explicitly defined. Unlike industry projects where a Product Owner typically represents the end-users and stakeholders, our university project may involve collaborative decision-making among team members, professors, and project advisors.

### Scrum Master (@11709469)
In our student university project, the Scrum Master serves as a facilitator, problem solver, and advocate for SCRUM principles. Key roles include:

1. **Facilitator:** Orchestrates SCRUM ceremonies, ensuring smooth collaboration during Sprint Planning, Daily Standups, Sprint Reviews, and Retrospectives.

2. **Impediment Remover:** Identifies and eliminates obstacles that may hinder the team's progress, promoting a productive and focused work environment.

3. **Team Support:** Acts as a supportive figure for team members, fostering an atmosphere of open communication and collaboration.

4. **Adherence to SCRUM:** Champions adherence to SCRUM principles by coaching and guiding team members, promoting a culture of continuous improvement and self-organization.

In this student setting, the Scrum Master's multifaceted role is crucial to the success of our collaborative and iterative project.

### Development Team
The self-organizing development team includes the following students:
- @12331473 (Test Coordinator)
- @12249629 (Technical Architect)
- @11730105 (Documentation Coordinator)
- @11723544 (Team Coordinator) 
- @11709469 (SCRUM Master)

The specific roles are mandatory for passing the requirements for the university. 

## Artifacts

### Sprint 
A **Sprint** stands as a defined period during which the project team collaborates to produce a potentially shippable product increment. In our context, a Sprint spans one week, from Monday to Monday. We depict this through the milestones in GitLab, so each Sprint has his one Milestone.

### Increment
An **Increment** denotes the compilation of completed user stories and features delivered by the development team at each Sprint's conclusion. It constitutes a tangible, functional enhancement to the overall project. We track increments based on the requirements essential for the successful completion of the university course underlying the project.

### Issues
An **issue** serves as a singular work package, ideally achievable within one Sprint. Typically, multiple issues contribute to forming one feature. In specific cases, a feature may be represented by a single issue. An issue could have multiple assigned developers, but only one responsible developer assigned in git. An issue always has at least one reviewer.

### Product Backlog
The **Product Backlog** contains all work packages that are not done yet. The sum of these represents the features not yet implemented. The Product Backlog is not complete during development, but it is always defined to a level that allows planning for the next Sprint.

### Sprint Backlog
The **Sprint Backlog** contains all work packages planned to finish in the current Sprint. In other words we map the issues to the Sprint (Milestone)

## Ceremonies
For every ceremony, one team member shares his or her screen with the issue board.
 
### Sprint Planning (Monday: 6pm-7pm, inso office)
**Sprint Planning** is a pivotal ceremony where we transition from the dynamic Product Backlog, representing all pending issues, to the focused Sprint Backlog, which contains specific issues for the current Sprint. In this ceremony, the team reviews and refines the Product Backlog, selects priority issues, assesses capacity, fills up the issues with important explanations, and compiles the chosen issues into the Sprint Backlog. This process ensures a clear, achievable focus for the upcoming Sprint, fostering collaboration and transparency within our student university project.

### Daily Standup
Since the project is part of the university, we don't have a daily standup due to time constraints. Nonetheless, we are in permanent contact.

### Sprint Review (Friday: 2pm-3pm, online)
The **Sprint Review** is a pivotal ceremony concluding each Sprint in our student university project. It is a dynamic session where the team presents the Potentially Shippable Increment to each other and the supervisor. Mainly, we do this on Friday in our meeting with @alexander.heinisch. The goal is to ensure that every team member possesses sufficient information about each aspect of the product at any given time, enabling them to conduct or respond to discussions and inquiries effectively. This is also important to pass the exam. If an issue is finished just over the weekend, we will present these things at the beginning of our planning on Monday.

### Sprint Retrospective
While we may not have dedicated time for a specific Retro meeting, our team fosters an open-minded approach to continuous improvement. We encourage all team members to openly share insights, suggestions, and concerns at any point. This ongoing, open communication allows us to identify areas for improvement and collectively strive for better practices, enhancing our collaboration within the project. We will document these points within our Sprint Diary

## Definition of Done (DoD)

### Code Development
- [ ] Code is written following the team's coding standards.
- [ ] Code compiles without errors.
- [ ] All code changes are documented inline.

### Documentation
- [ ] User documentation is updated to reflect new features or changes.
- [ ] Technical documentation (e.g., API documentation) is updated.

### Testing
- [ ] Backend Unit tests pass and cover new functionality or changes (if necessary).
- [ ] Backend Integration tests pass and cover new functionality or changes (if necessary).
- [ ] Frontend Unit tests pass and cover new functionality or changes (if necessary).
- [ ] Frontend Widget tests pass and cover new functionality or changes (if necessary).
- [ ] Code has been tested.
- [ ] Edge cases and error scenarios are tested.

### Quality Assurance
- [ ] Code is reviewed by at least one team member.
- [ ] Functional requirements outlined in the user story are met.

### Deployment
- [ ] Code is merged to the main branch.
- [ ] Deployment scripts are updated.

### Performance
- [ ] Code changes do not significantly impact system performance.
- [ ] Load and stress testing, if applicable, are performed successfully.

### Clean Up
- [ ] Unused code, comments, and debugging artifacts are removed.
- [ ] Branches associated with the ticket are merged or closed.

### Communication
- [ ] Team members are informed about the completion of the ticket.

## Tools
We use GitLab for SCRUM management.

