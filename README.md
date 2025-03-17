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

### Version 2.0
🔄 **What’s New?**
- **Complete Rework** – The script has been fully reworked, taking inspiration from vorp_npcloot to integrate item rewards.
- **Configurable Reward Items** – You can now define which items NPCs drop upon robbery.
- **Added translations.lua** – Makes translations easier and more accessible.
- **Gold & Money Rewards** – NPCs can now reward both gold and in-game currency.
- **Improved NPC Behavior** – When a robbery starts, NPCs will now turn towards the player and raise their hands.
- **Implemented surrenderDuration** – Determines how long you must aim at an NPC before receiving rewards.

🔜 **What’s Coming Next?**
- **Max Robbery Distance** – Configurable maximum distance for initiating a robbery.
- **NPC Aggressiveness** – Reimplementation of NPC resistance (currently removed due to issues).
- **Configurable Weapons** – Define which weapons can start a robbery (currently, any weapon can trigger it).

### Version 1.3
- **Added:** Players must aim at an NPC for at least 3 seconds before the robbery is triggered. This prevents accidental robberies when aiming at crowds.
- **Added:** A weapon check – players must have a weapon equipped to start a robbery.

### Version 1.2
- **Added:** A human ped check to prevent animals from being robbed.
- **Fixed:** NPC's now do the money giving animation correctly. Previous animations are canceled.
- **Fixed:** Issue where animals could trigger the robbery script.

### Version 1.1
- **Improved:** Script structure reorganized – `client.lua` and `server.lua` are now inside dedicated `client` and `server` folders for better project organization.


## 🔧 Installation
1. Download and place the script in your `resources` folder.
2. Add `ensure owc_robbery` to your `server.cfg`.
3. Restart your server.

## ⚙️ Configuration (`Config.lua`)
Modify the `Config.lua` file to customize behavior.
