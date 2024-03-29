import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Comparator;
import java.util.HashMap;

public class Main {
    static class Pair {
        public final String ts;
        public final String cmd;

        public Pair(String ts, String cmd) {
            this.ts = ts;
            this.cmd = cmd;
        }

        public String toString() {
            return ts + "\n" + cmd;
        }
    }

    public static void main(String[] args) throws IOException {
        var previousCommands = new HashMap<String, Pair>();
        long unixTime = LocalDateTime.now().minusWeeks(1).toEpochSecond(ZoneOffset.UTC);
        long count = 0;
        String bashHistory = System.getProperty("user.home") + File.separator + ".bash_history";

        // Backup the file
        var copied = Paths.get(bashHistory + ".bak");
        var originalPath = Path.of(bashHistory);
        Files.copy(originalPath, copied, StandardCopyOption.REPLACE_EXISTING);


        try (BufferedReader br = new BufferedReader(new FileReader(bashHistory))) {
            String line, command, timestamp;
            while ((line = br.readLine()) != null) {
                var cleanedLine = line.stripTrailing().stripLeading();
                if (cleanedLine.isEmpty()) {
                    continue;
                }
                if (cleanedLine.charAt(0) == '#') {
                    var nextLine = br.readLine();
                    if (nextLine.isEmpty()) {
                        continue;
                    }
                    if (nextLine.charAt(0) == '#') {
                        continue;
                    }
                    command = nextLine.stripTrailing().stripLeading();
                    timestamp = cleanedLine;
                } else {
                    command = cleanedLine;
                    timestamp = "#" + (unixTime + count);
                }
                previousCommands.putIfAbsent(command, new Pair(timestamp, command));
                count++;
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }

        try (BufferedWriter writer = new BufferedWriter(
                new FileWriter(bashHistory, false))) {
            var commandsToSave = previousCommands
                    .values()
                    .stream()
                    .sorted(Comparator.comparing(l -> l.ts))
                    .filter(p -> !badCommands(p))
                    .toList();

            for (var cmd : commandsToSave) {
                writer.write(cmd.toString() + "\n");
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    private static boolean badCommands(Pair pair) {
        return pair.cmd.isEmpty()
                || pair.cmd.charAt(0) == '│'
                || pair.cmd.matches("^(cd|cat|ls|rm|mv|ssh|vi|srv|nvim|idea|EOF|EOH|hoistname|srbn|srn|dk|mkdir|exot).*")
                || pair.cmd.matches("^docker exec .*")
                || pair.cmd.matches("^history_cleaner .*")
                || pair.cmd.matches("^k (logs|delete) .*")
                || pair.cmd.matches("^git (commit|push|pull|rebase|stash|merge|reset|diff|checkout|branch|status|stah).*")
                || pair.cmd.matches("^[0-9|\":\\]].*");
    }
}
