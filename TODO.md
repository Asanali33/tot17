# TODO: Persist Collaborators to Database

## Backend
- [x] Create `backend/models/TeamMember.js`
- [x] Create `backend/routes/teamMembers.js`
- [x] Register route in `backend/server.js`

## Frontend
- [x] Update `lib/models/team_member.dart` (add toJson/fromJson)
- [x] Update `lib/services/task_service.dart` (add backend CRUD for team members)
- [x] Update `lib/screens/home_screen.dart` (load team members on init)
- [x] Update `lib/screens/collaboration_screen.dart` (async add/remove with backend calls)

## Follow-up
- [ ] Restart backend
- [ ] Test persistence

