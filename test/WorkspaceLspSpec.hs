module WorkspaceLspSpec (spec) where

import Control.Monad.IO.Class (liftIO)
import Data.Text qualified as T (pack)
import Language.LSP.Protocol.Types as LSP
import Language.LSP.Test
import System.FilePath ((</>))
import System.IO qualified as IO (readFile)
import Test.Hspec

exampleRoot :: FilePath
exampleRoot = "external" </> "jbeam-edit" </> "examples"

runJbeamSession :: FilePath -> Session a -> IO a
runJbeamSession jbflFile = runSessionWithConfig cfg cmd fullLatestClientCaps exampleRoot
  where
    cmd = "jbeam-lsp-server -c " <> jbflFile
    cfg =
      defaultConfig
        { logStdErr = True
        }

formatVerify :: FilePath -> FilePath -> Session ()
formatVerify jbeamFile expectedFile = do
  doc <- openDoc jbeamFile "jbeam"

  formatDoc doc (LSP.FormattingOptions 0 False Nothing Nothing Nothing)

  formatted <- documentContents doc
  expected <- liftIO (T.pack <$> IO.readFile expectedFile)

  liftIO $ formatted `shouldBe` expected

jbflTests :: [(FilePath, FilePath, FilePath)]
jbflTests =
  [
    ( "jbeam" </> "fender.jbeam"
    , exampleRoot </> "formatted_jbeam" </> "fender-minimal-jbfl.jbeam"
    , exampleRoot </> "jbfl" </> "minimal.jbfl"
    )
  ,
    ( "jbeam" </> "fender.jbeam"
    , exampleRoot </> "formatted_jbeam" </> "fender-complex-jbfl.jbeam"
    , exampleRoot </> "jbfl" </> "complex.jbfl"
    )
  ]

workspaceSpec :: Spec
workspaceSpec =
  describe "JBeam LSP Formatter" $
    mapM_
      ( \(jbeam, expected, jbfl) ->
          it ("formats " <> jbeam <> " correctly") $
            runJbeamSession jbfl (formatVerify jbeam expected)
      )
      jbflTests

spec :: Spec
spec = workspaceSpec
