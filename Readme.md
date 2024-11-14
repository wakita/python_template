# Python project のサンプル

このサンプルはいくつかの設定を含んでいる。

- `/src/.../*.py` と `notebooks/*.ipynb` のいずれからも `src/` の下のモジュールを `import` できる。
- 自分の PC でも TSUBAME4 でも同様に Python プログラムや Jupyter Notebook を実行できる。

# 前提条件

1. 自分の PC と TSUBAME4 に Python 3 の仮想環境を作成してあること。

    それらは同名で `$HOME` 相対で同じパスに作成されていること。たとえば、`$HOME/.venvs/smartnova` など。

1. FreeFileSync で自分の PC と TSUBAME4 の間で同期を取る設定をしていること。

    たとえば、自分の PC の `$HOME/Dropbox/projects/my_project/` と TSUBAME4 の `$SN/work/wakita/my_project/` の間など。

    FreeFileSync についての簡単な説明は [scrapbox](https://scrapbox.io/smartnovax/TSUBAME4_とファイルを同期したいのなら_FreeFileSync) を参考にしてほしい。

# TSUBAME4 の利用

TSUBAME4 用のジョブスクリプトは `run/job.sh` を参考に作成する。いくつかの設定項目は必ず変更すること。

1. `#$ -M wakita@is.titech.ac.jp` は自分のメールアドレスに変更すること。
1. `export VENV_PATH=$HOME/.venvs/smartnova` は自分の Python 仮想環境のパスに変更すること。
1. ノード構成 (`#$ -l cpu_4=1` と `#$ -l h_rt=00:01:00`) の指定も適宜変更すること。

スクリプトの働きについては、ジョブスクリプトのコメントを参照すること。

`run/submit.sh` スクリプトは研究室の TSUBAME グループを使って `run/job.sh` ジョブスクリプトを `qsub` で投入する。

ジョブを投入したらすぐに `qstat` でジョブの状況を確認し、ステータスが `r` になるまで待つこと。ステータスが `Eqw` になった場合は、ジョブスクリプトに問題がある。[FAQ ページ](https://www.t4.gsic.titech.ac.jp/docs/faq.ja/scheduler/) を読んで、対応すること。わからない場合は研究室の Slack で質問。

ジョブスクリプトの実行結果とエラーは `log/{job_id}.{out,err}` に出力される。`.out` が正常出力で普通は空のはず。`.err` にエラーが出力される。ジョブスクリプトで `jupyter execute ...` を実行すると、正常終了時にかならずエラーが出力される。`/proc/...` をアクセスに行って、アクセス不許可なためにエラーになっているようだ。TSUBAME4 のシステムアーキテクチャに依存したエラーかもしれないが、詳細は不明・要調査。ひとまず無視。以下がエラーの例。

~~~
[NbClientApp] Executing notebooks/test.ipynb
[NbClientApp] Executing notebook with kernel: python3
[IPKernelApp] ERROR | Exception during subprocesses termination [Errno 1] Operation not permitted: '/proc/1/stat'
Traceback (most recent call last):
  File "/home/2/us03322/.venvs/smartnova/lib/python3.13/site-packages/ipykernel/kernelbase.py", line 1406, in _at_shutdown
    await self._progressively_terminate_all_children()
  File "/home/2/us03322/.venvs/smartnova/lib/python3.13/site-packages/ipykernel/kernelbase.py", line 1384, in _progressively_terminate_all_children
    if not self._process_children():
           ~~~~~~~~~~~~~~~~~~~~~~^^
  File "/home/2/us03322/.venvs/smartnova/lib/python3.13/site-packages/ipykernel/kernelbase.py", line 1367, in _process_children
    all_children = kernel_process.children(recursive=True)
  File "/home/2/us03322/.venvs/smartnova/lib/python3.13/site-packages/psutil/__init__.py", line 972, in children
    ppid_map = _ppid_map()
  File "/home/2/us03322/.venvs/smartnova/lib/python3.13/site-packages/psutil/_pslinux.py", line 1695, in ppid_map
    with open_binary("%s/%s/stat" % (procfs_path, pid)) as f:
         ~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/2/us03322/.venvs/smartnova/lib/python3.13/site-packages/psutil/_common.py", line 799, in open_binary
    return open(fname, "rb", buffering=FILE_READ_BUFFER_SIZE)
PermissionError: [Errno 1] Operation not permitted: '/proc/1/stat'
[NbClientApp] Save executed results to notebooks/test-1582323.ipynb
~~~

# Python code を Jupyter Notebook に `import ...` する方法

`notebooks/initialize/__init__.py` を用意し、`test.ipynb` のようにノートブックの先頭に `import initialize` しておけば、`src/` の下のモジュールを普通に `import` できるようになる。

# `vscode-open` by sandcastle は便利

この VSCode extention をいれると、Explorer のファイルを右クリックして `Open with default application` すると、外部のアプリケーションでそのファイルを開くことができる。たとえば：

- `tsubame4.ffs_gui` で FreeFileSync を開く。
- `out/spi.csv` で Numbers を開く。
- `data/SPI2011-2023.xlsx` で Excel を開く。