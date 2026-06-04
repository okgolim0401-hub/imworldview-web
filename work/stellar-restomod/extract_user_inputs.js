const fs = require('fs');
const readline = require('readline');

const logPath = "C:\\Users\\PC\\.gemini\\antigravity\\brain\\b9d00a28-3c74-4dcb-897d-7f8c2a796992\\.system_generated\\logs\\transcript.jsonl";

const rl = readline.createInterface({
    input: fs.createReadStream(logPath, { encoding: 'utf8' }),
    output: process.stdout,
    terminal: false
});

rl.on('line', (line) => {
    try {
        const data = JSON.parse(line);
        if (data.type === 'USER_INPUT') {
            console.log(`Step ${data.step_index}: ${data.content}`);
            console.log("-".repeat(40));
        }
    } catch (e) {
        // Ignore JSON parse errors
    }
});
