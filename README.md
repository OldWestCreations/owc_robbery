# NPC Robbery Script for RedM (VorpCore)

This is my **first release**, and the script may not be optimally written. Feel free to provide feedback or suggestions for improvements!  

This script allows players to rob NPCs by aiming at them with a revolver or pistol. NPCs will either surrender and give money or fight back.

## 📌 Features
- NPCs can **surrender** and hand over money.
- NPCs can **fight back** using fists or a revolver.
- NPCs freeze during the decision-making process.
- Configurable settings for **surrender chance, money drop, and weapon chance**.
- Integrated **animation** for money handover.

## 🔄 Changelog

### Version 1.1
- **Added:** A human ped check using `IsPedHuman()` to prevent animals from being robbed.
- **Fixed:** Issue where animals could trigger the robbery script.
- **Improved:** Script structure reorganized – `client.lua` and `server.lua` are now inside dedicated `client` and `server` folders for better project organization.

This update ensures that only human NPCs can be targeted for robbery, improves script clarity, and enhances project structure.


This update ensures that only human NPCs can be targeted for robbery, improving gameplay realism.

## 🔧 Installation
1. Download and place the script in your `resources` folder.
2. Add `ensure owc_robbery` to your `server.cfg`.
3. Restart your server.

## ⚙️ Configuration (`Config.lua`)
Modify the `Config.lua` file to customize behavior.
