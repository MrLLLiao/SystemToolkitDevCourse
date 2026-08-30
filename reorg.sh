#!/usr/bin/env bash
set -e
cd /root/gitRepo/SystemToolkitDevCourse

mkdir -p week1/report
git mv q01 q02 q03 q04 week1/
git mv reports/week1.tex reports/week1.pdf week1/report/
git add -A
git commit -m "chore(reorg): 将q01-q04和第1周实验报告移入week1目录"
echo WEEK1 DONE

mkdir -p week2/report
git mv q05 q06 q07 q08 week2/
git mv reports/week2.tex reports/week2.pdf week2/report/
git add -A
git commit -m "chore(reorg): 将q05-q08和第2周实验报告移入week2目录"
echo WEEK2 DONE

mkdir -p week3/report
git mv q09 q10 q11 q12 week3/
git mv reports/week3.tex reports/week3.pdf week3/report/
git add -A
git commit -m "chore(reorg): 将q09-q12和第3周实验报告移入week3目录"
echo WEEK3 DONE

mkdir -p week4/report
git mv q13 q14 q15 q16 week4/
git mv reports/week4.tex reports/week4.pdf week4/report/
git add -A
git commit -m "chore(reorg): 将q13-q16和第4周实验报告移入week4目录"
echo WEEK4 DONE

rmdir reports 2>/dev/null || true
git add -A
git commit -m "chore(reorg): 移除空reports目录" --allow-empty
echo ALL DONE
git status
