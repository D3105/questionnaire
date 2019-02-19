# questionnaire

## Known issues:
- Authentication screen:
    - [ ] 'Retype Password' field not checked for resembling until all required field's streams receive at least one event;
    - [x] When user go to home screen, field's streams forget last event, so you need to update each one. **Solution: make bloc singleton**.
    - [ ] Text copied from first field of signIn to first field of signUp and so on.