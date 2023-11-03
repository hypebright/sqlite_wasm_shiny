
let db;

function loadDB(filePath) {
  fetch(filePath)
    .then(response => response.arrayBuffer())
    .then(buffer => {
      const config = {
        locateFile: filename => `/dist/${filename}`
      };

      initSqlJs(config).then(SQL => {
        try {
          const Uints = new Uint8Array(buffer);
          db = new SQL.Database(Uints);

        } catch (error) {
          console.error("Error creating database:", error);
          Shiny.setInputValue("queryResult", error, {priority: "event"});
        }
      }).catch(error => {
        console.error("initSqlJs error:", error);
      });
    })
    .catch(error => {
      console.error("Error loading database:", error);
    });
}


function executeQuery(sqlQuery) {
  try {
    
    if (db) {
      console.log(sqlQuery);
      
      const results = [];
      const stmt = db.prepare(sqlQuery);
      
      if (stmt) {
        stmt.getAsObject({$start:1, $end:1});

        // Bind new values
        stmt.bind({$start:1, $end:2});
        
        while (stmt.step()) {
          const row = stmt.getAsObject();
          results.push(row);
        }
        
        console.log(results)
        
        Shiny.setInputValue("queryResult", JSON.stringify(results), {priority: "event"});
        
      } else {
        console.error('Statement not prepared');
        Shiny.setInputValue("queryResult", "Error: statement not prepared", {priority: "event"});
      }
      
    } else {
      throw new Error("Database not loaded.");
    }
  } catch (error) {
    console.error("Error executing query: " + error.message);
    Shiny.setInputValue("queryResult", error.message, {priority: "event"});
  }
}

