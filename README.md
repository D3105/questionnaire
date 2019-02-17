# questionnaire

A new Flutter project.

## Known issues:
- Authentication screen:
    - 'Retype Password' field not checked for resembling until all required field's streams receive at least one event;
    - When user go to home screen, field's streams forget last event, so you need to update each one.