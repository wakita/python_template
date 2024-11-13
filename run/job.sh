#!/bin/sh
# TSUBAME4 のジョブスケジューラに与えるタスクの記述

# カレントディレクトリでジョブを実行する
#$ -cwd

# 最小構成のノードで max 1 分実行する。
#$ -l cpu_4=1
#$ -l h_rt=00:01:00

#  ジョブの出力先を log ディレクトリにする
#$ -o log/$JOB_ID.out
#$ -e log/$JOB_ID.err

# ジョブが終了した場合 (e)、エラーになった場合 (a)、停止した場合 (s) にメールを送る。
#$ -M wakita@is.titech.ac.jp
#$ -m eas

# 仮想環境のパス
export VENV_PATH=$HOME/.venvs/smartnova

# このスクリプトは自分の PC からも、TSUBAME4 で qsub したジョブのなかからも呼び出せる。手元で実行する場合は
# 0. project_template ディレクトリから実行するように。ほかのディレクトリで実行するとエラーになる。
# 1. 自分の PC で試しに `run/run_notebook.sh` して、うまくいくことを確認したら
# 2. TSUBAME4 で `run/submit.sh` を実行しジョブを投入する。
#    1. `qstat` コマンドでジョブの状況を確認できる。
#    2. `qdel <ジョブID>` でジョブを削除できる。

if [ -f $VENV_PATH/bin/activate ]; then
    # 仮想環境を起動してノートブックを実行
    source $VENV_PATH/bin/activate
    # --output オプションをつけると、ノートブックの出力をファイルに保存できる。このオプションがない場合は、jupyter execute の実行結果のノートブックはどこにも保存されない。
    jupyter execute --output="{notebook_name}-$JOB_ID" notebooks/test.ipynb
else
    echo "$VENV_PATH に仮想機械が見つかりません。"
fi
