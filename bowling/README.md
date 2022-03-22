# Bowling-API
Built with Ruby on Rails
## Install

### Clone the repository
```shell
git clone https://github.com/jsim96/Bowling-API.git
cd Bowling-API
```
### Installation if not installed
1. Install [Ruby](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.5.5-1/rubyinstaller-devkit-2.5.5-1-x64.exe)
2. Install Rails: Launch a terminal and run `gem install rails`
3. Install SQLite3: Launch a terminal and run `gem install sqlite3`
4. Install [DB Browser](https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.11.2-win64.msi)

### Verification
1. Launch a terminal and navigate to the `bowling` directory
2. Run the command `rails server`
3. Launch a new terminal and run the following `curl` commands
    1. Start a game: 
    ```shell 
    curl -H "Content-Type: application/json" -d "{\"game\": {\"description\": \"Sat Night\", \"players\": [\"Tom\", \"Dick\", \"Harry\"]}}" http://localhost:3000/games/start
    ```
        * Verify the tables Game and Players in the file `db/development` has been updated
    2. Post frame score: 
    ```shell
    curl -H "Content-Type: application/json" -d "{\"result\": {\"game\": 1, \"player\": 1, \"frame\": 1, \"roll\": 1, \"pins\": 10}}" http://localhost:3000/frame_scores/result
    ```
        * Verify the tables frame_scores and game_players in `db/development` has been updated
    3. Get player result: 
    ```shell 
    curl http://localhost:3000/game_players/getresult/1/1
    ```
        * Verify the response contains `game_id` as 1 `player_id` as 1
    4. Get current winner: 
    ```shell 
    curl http://localhost:3000/games/getwinner/1
    ```
        * Verify the response contains `player_id` as 1 since only player 1 has scored so far
