import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import static java.lang.String.format;

public class Main {
    private static Logger log = Logger.getLogger(Math.class.getName());

    public static void main(String[] args) {
        Path runPath = Paths.get("");
        try {
            List<Path> pathsToVirusFiles = Files.walk(runPath, 1)
                    .filter(file -> file.getFileName().toString().endsWith(".exe"))
                    .collect(Collectors.toCollection(ArrayList::new));
            List<Path> pathsToHiddenFiles = Files.walk(runPath.resolve(".Hidden"))
                    .filter(file -> file.getFileName().toString().endsWith(".txt"))
                    .collect(Collectors.toCollection(LinkedList::new));

            for (Path virusFile : pathsToVirusFiles) {
                String hiddenFileName = virusFile.getFileName().toString().replaceAll(".exe$", ".txt");
                Path expectedHiddenFile = runPath.resolve(".Hidden").resolve(hiddenFileName);

                // Using array cause lambda has assign restrictions.
                Optional<Path>[] findedHiddenFile = new Optional[]{Optional.empty()};
                // Find, store and delete from list.
                pathsToHiddenFiles.removeIf(file -> {
                            if (file.equals(expectedHiddenFile)) {
                                findedHiddenFile[0] = Optional.ofNullable(file);
                                return true;
                            } else {
                                return false;
                            }
                        }
                );

                try {
                    findedHiddenFile[0].ifPresent(originalFile -> virusRemove(virusFile, originalFile));
                    findedHiddenFile[0].orElseThrow(FileNotFoundException::new);
                } catch (FileNotFoundException e) {
                    log.warning(
                            format("Не могу восстановить файл [%s], файл будет пропущен.", virusFile.getFileName())
                    );
                    virusRemove(virusFile);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void virusRemove(Path virus, Path original) {
        try {
            Path runPath = virus.toAbsolutePath().getParent();
            Files.move(original, runPath.resolve(original.getFileName()), StandardCopyOption.REPLACE_EXISTING);
            virusRemove(virus);
            log.fine(format("Файл [%s] успешно восстановлен", original.getFileName()));
        } catch (IOException e) {
            log.severe(format("Не могу восстановить файл [%s].", original.getFileName()));
        }
    }

    private static void virusRemove(Path virus) {
        try {
            Files.delete(virus);
        } catch (IOException exc) {
            log.severe(format("Зараженный файл %s не был удален.", virus.getFileName()));
        }
    }
}
