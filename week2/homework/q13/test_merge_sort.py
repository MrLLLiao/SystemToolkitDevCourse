import pytest

from merge_sort_fixed import merge_sort


@pytest.mark.parametrize(
    "data,expected",
    [
        ([3, 1, 4, 1, 5, 9, 2, 6], [1, 1, 2, 3, 4, 5, 6, 9]),  # 讲义测试向量
        ([], []),
        ([1], [1]),
        ([2, 1], [1, 2]),
        ([5, 4, 3, 2, 1], [1, 2, 3, 4, 5]),
        ([1, 2, 3, 4], [1, 2, 3, 4]),
        ([7, 3, 3, 9, 1, 7, 2], [1, 2, 3, 3, 7, 7, 9]),
    ],
)
def test_merge_sort(data, expected):
    assert merge_sort(data) == expected
