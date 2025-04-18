from first_evey_dabs_build.main import get_taxis, get_spark


def test_main():
    taxis = get_taxis(get_spark())
    assert taxis.count() > 5
