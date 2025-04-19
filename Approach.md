Required functionality
[User enters Email/Phone]
       ↓
Flutter frontend sends request to backend → /api/check-breach
       ↓
Backend validates + checks breach via HIBP API
       ↓
If breached → uses GenAI to explain in simple language
       ↓
Response sent back to frontend → Shows user + stores in Hive
       ↓
Push notifications enabled (via Firebase) for future breaches
       ↓
VPN/IP status periodically fetched via VPN API
       ↓
Vault uses encrypted local storage to store sensitive info


Mehtod
Step1)I think we must focus on a scalable backend ....first we should create our api endpoints-
->check breach via email or phone number
->monitor breach like a stream 

Step2)Then following ai agents:
->breachCheck response analyzer
->Past Reports reading agent(wit corresponding databse)
->Advisor agent
->Vault Manager Agent(If required)

Step3)Flutter WebApp should have following screens and features as an endproduct:
->User authentication via email and password
->Profile section with user name , email,phone number
->Monitoring Screen showing past alerts 
->Vault Screen
->AI Assistance screen and checker screen as one 
->Ai assistance bot that uses simple ai to tell about website

MCP should be followed and everything should be non-harcoded , simple ui which will be updated later 



