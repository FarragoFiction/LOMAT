/*
 fenrir needs to be able to write words to the screen. roughly at head height. similar to magical girl sim
 needs to be timed, for him to just say BORK at you. and then say more things
 maybe sounds that are audio libed?
 */
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';

import '../Game.dart';
import '../GameStats.dart';
import '../NPCs/Tombstone.dart';
import '../SoundControl.dart';

class Fenrir {

    static String HAPPY="HAPPY";
    static String NEUTRAL="NEUTRAL";
    static String ANGRY ="ANGRY";
    static Element fenrirElement;
    static bool deleted = false; //if fenrir is deleted, print text anytime you try to visit him
    static bool onScreen = false;

    static String get opinion {
        GameStats gs = Game.instance.gameStats;
        if(gs.theDead.isEmpty && gs.voidVisits < 2) {
            return NEUTRAL;
        }else if(gs.theDead.isEmpty) {
            return HAPPY;
        }else if(gs.theDead.length < 2) {
            return NEUTRAL;
        }else {
            return ANGRY;
        }
    }

    static String friendText = "jgEHUBYIYC4AQMYQHYwJ4HsCuMoFMA2eMAtjjBAEaaxRgCWAzjAOYQkD8guAQA0qmZ9Aax4AHNHlq48KAHQwYAeQBm8TACd6OHuiwDEaAO4wcANxyqUNWoibYwZ0g2xoYug2UoZqdRixKyAogCOGBAEKFp8GIgAJmb0UEjRttC2pPTBEPoCVjZMGAQw5DiKaKqk2jwQxBAI5GXEtAAeMGjKoYTaqi14SYqqtDgx9DwIyHqwNVAhYTD0EChkiBZ01jAYGor5hTUCsgBCnqn1EPX0aCS2OYxoiGm0RMJSMAAi8v4AypUxs8I4ENmrKDOTrwSCqJg4RhFEr1RRmcw5VJEGCOG6kVpI6QAHjqAD4capccB3gBFEAAQRAAGkAIR0ukwACqADUYCB3gAZAASAC0OTAAHJcgAq-J55OZIBgPK5AGF+XseTAAEoABXe7xgiulEql5PkqqVAEk9gBNABiWp59Lp3FSTlUJEQuCSeQK9DA-RwAnoshgpr4emiPBomCYYCgmzC2LxBNxyr+4igC0U4mEvrjcYDGC6cFoqjgGAkjA0OGRQNmcFUrHIeBwskzeOzZH0J0GkKheDQ9DOREYwgg8UYNFI4iIEjixD+zqcLhwOGEvCwmTbLWUNyeaOw93wVk0iySG4WoY0LWQI5g-XDsHotFia-tIHafubZVCtAAXqQL-JyBpVKY6gwJApgqM6qhiHWSQgiYZgLJMtA3DwGCLlEUC0IQej6LIApuNoZCwmU9YwMKdgwMAexoFAHCFJ4QLII4egwF21hmE4TBMFBMaEnGpGkL+-6AYwIGkJMODRLIfEwOSBTmtAdhdI4cCQKxEkkQpDiMExrYLP4+a0AIXTRGgkIwOMLhYZcvpyI2hLNnUAypgsrbxN+O4wPoDArDYILCBBTDVkQ46rO0BjiUus6Fuo+7kIcIKym+QKqDwzyQgOi6yhI0BoDwLkwMEE7wHWJxnvaZyqFA1zKEUIGIV0EDCH5aB+bQ0CkDCZDMWFuZ4IOjB5uhX6INx+J4kaiCuRAwYRbesDGfoyA3PaVZRMpCzjs0GL0JZiQonAxF8fUjHOOhJDiLcHkaZc1g+M40S0IocJlM6Ughldx1kHA6FLfhozYP837OMpSAQosyw5LI7zAnwJBlE8rYSA2sZ4np-SGREObAW1STGY1+AsKxyWzGABiMChXxJAkAimSC7wgP4-jCjAzJGlSRoCgA4jAHLkgKzxavI5JM305wRZ5oaHLB55kXAai4PQCwYlUJBIDkUbML1iD7S+fBVpkhBWPa5A7DwRQIOs5Qw-M-AefghBFEcgMeRItw9va-gxH6tm4lypDGZCiCAJgEsCuIYJOGBWjzzDwGKyzmGgU0YpjSxBGDhkuXSIBgRDkDAsT0AO+YRZAuDAfcMAAFbrBMzESFAdaFBIxClO1pRl4we7COhUyxLIzb6PYtEYdQzhR8e3jMKw+4VjgjT7YQKQSCGziz-t4V0MihuweYMCiD2tC1qQOmQ84+hgAsjhN2REKVbOHp7geS6B6cUxwAI2xv8B9hsN7MC+3nJltrB0KFRBS-08AAhsBWC8bo8DDEfg9VI60AZmTQAwUyMtPDDjsMiVoihZD-0mIwcQ1MUS3z3reQ+s4BTyCZg7Ls8RSqWGIYkP0-8C6DGiIwHSThnBEAwMpbcFwPRoCooiC88RqysVojYds45ISmxwObBOD447RR4GRf2QDYBvnEF+MhjAqiiCsPXDsDREC0BYIAMgIRpxnANAWxTY+BwnwLMBI6E4AomQCCPMBYiy30HBnPOkJ8xOyiqeKwVY-gaGsqjAyRMaApBJr8OsPZkIaFSSwlAFAqB51UFEXY6kUjGJeh2Hg+Y4YmCQFAcpDwqKDB0TgIohAz7ODKJsGJs4pYAPtFuBIggv4eUCYobGs5jIEMCcVVQtwkjh1nEQQcuAugXmZGgymnowxgGSLAEppi3bBUsVPSSZEOS7TKLLJgFivzCXLoE4sMAACyiy2KGyqDwputxAKXiUWgS5n5wraFkKlAuhUQRoHIMYRC6xZgoTMHVCQF9kCCXEWRGShA5IjlUI4wkRooCB2uIgJ4wVPCmTQhhe0igrChGYPkA2UIcwDCSLtc0gx+iKUMY1CCNQ7BqWbKHQoOAoBLOSOeZwyTvwl22S0P86FEBtQAUwXKJMIo3H2mBW8sQyiU2cA7KofQBgxFypgHoAr3ANwrLEOEKQ4mGQCMnWwmzBllA0LAX6mBSlu1OqZV5hM7WDAdWnLZ+EB4vwEe-cWWykBrEQEUaAFAG6+GIv4e1Et07BsHnsRkRoORMwrLG2AiNvY2qMoA2Y5xBXeWkFW3FAByRgAJDzKDBNq2Y85pCJxZYgNlACA7ANngwKAfdIgxDiAkb4F57qPXsFrUgRQoAD39YkiY3xYb4AWEUREsQpoBH0oZZifxTDwL8pCbO8bjzOCYCdHeFZzQAEYAAaJEuS3s1BG+0zrYAYgvLgVgUr4gYUICUAgpN7TyBNU+FAvoABQUHmyrlCGibFuI0VBNgTAfVnDDH1C3RJItKayJyoLAwW8jDjI2EcJe24SG4PHBYvWb2T4JA0n9JgZ+pBxjMdIikAe+ZoJ2zcO+QYPBTQChRFVZQhsJ0DqQPtHgXY0CQKCcfOQUlWyOhoA+cV6GAOMBBElM4j8RzIDIs1QYhi3FSNBlq3epQEgL2+BRxDMBvbNhcYQC80BcDOkQotZQP4-xmCEkPE1KEjB6EDYnXR-yIp-SoMIQ4VRbzWAbsSOgg6aKRwgr8VQTxZ7HrdiCWaIRvrDW9lDEglhVicRMdwq6HnxD+sgEkIoQmA3hkTr9KN5k3HNQzhk5QItkQF36N5wEBgThcLISMNAnmIAYUYKmBqwhESSbInUec+jXkwEAgsKIABaWKpicsGVIAsxAtwsVsjsN4vggg7yzkS0CYQGNtPfCQKAtiEFKCwCkIiJaMDU6GtbWWREstEAdPEgQ0coifRVukL2HAZ8UgkIlaJBr0sUhV0YXWRQNTaKwDfSTaZhi3swuy3VKcdmQHRBkN7UAyrVzaE4BFQcQgzJ-By4rZAEBPDnGgLQOASHgBI7mtDLAKtEBsCl2wFE9IyDIhIDaGkHAodidBPOVQUZTaHFLH2MCEO1J07hyxrA8n34o7-VASz5R+OGEE8NOQRp5fMDQWN+A7QIooEQJRdLdO0BgCV8x+QAh5g2houpS+jB+GCLncKxJyAN0hTo0hkAEgSaHEq5Al7cW4pqDcYkCbMBAAYBOc-JEhA5Th7BAUGHVYHWWAM8MXQyZwVgrq7qcnA6dt8NvhDqIvpccBc3wUIRBuw3mr9rkO85FyPYesoFC2Xa4z85c1fo8qOpVAOEdmFgjAmdH67IXFX88DplnA7Cr7QBcIK1g1eN6JlD0AwOQUxLRFKIGMGINCJwFhljETcaleWzqt4NwfoJuPS5kIkYMLuoQJO60LcsgKGjgDCg6V2zkxqTKxAkGSyUKjAX2VEzsHos43eN2GAQuTuxkqCIclkfeJcxyg8x0lWNgOO6WEUlKcqMwzqogQOx6A4I2Pkag-W6GbcUagqZgFiyYZAyefuIeKANoKItcpCU0ycUwZQYeNkyMdkeecqFwjgW+dYqgPuHWw+9QkAjUtOGho0hIQAA";
    static String observerText = "jgEHUBYIYC4AQMYQHYwJ4HsCuMoFMA2eMAtjjBAEaaxRgCWAzjAOYQkD8guAQA0qmZ9Aax4AHNHlq48KAHQwYAeQBm8TACd6OHuiwDEaAO4wcANxyqUNWoibYwZ0g2xoYug2UoZqdRixKyAogCOGBAEKFp8GIgAJmb0UEjRttC2pPTBEPoCVjZMGAQw5DiKaKqk2jwQxBAI5GXEtAAeMGjKoYTaqi14SYqqtDgx9DwIyHqwNVAhYTD0EChkiBZ01jAYGor5hTUCsgBCnqn1EPX0aCS2OYxoiGm0RMJSMAAi8v4AypUxs8I4ENmrKDOTrwSCqJg4RhFEr1RRmcw5VJEGCOG6kVpI6QAHjqAD4capccB3gBFEAAQRAAGkAIR0ukwACqADUYCB3gAZAASAC0OTAAHJcgAq-J55OZIBgPK5AGF+XseTAAEoABXe7xgiulEql5PkqqVAEk9gBNABiWp59Lp3FSTlUJEQuCSeQK9DA-RwAnoshgpr4emiPBomCYYCgmzC2LxBNxyr+4igC0U4mEvrjcYDGC6cFoqjgGAkjA0OGRQNmcFUrHIeBwskzeOzZH0J0GkKheDQ9DOREYwgg8UYNFI4iIEjixD+zqcLhwOGEvCwmTbLWUNyeaOw93wVk0iySG4WoY0LWQI5g-XDsHotFia-tIHafubZVCtAAXqQL-JyBpVKY6gwJApgqM6qhiHWSQgiYZgLJMtA3DwGCLlEUC0IQej6LIApuNoZCwmU9YwMKdgwMAexoFAHCFJ4QLII4egwF21hmE4TBMFBMaEnGpGkL+-6AYwIGkJMODRLIfEwOSBTmtAdhdI4cCQKxEkkQpDiMExrYLP4+a0AIXTRGgkIwOMLhYZcvpyI2hLNnUAypgsrbxN+O4wPoDArDYILCBBTDVkQ46rO0BjiUus6Fuo+7kIcIKym+QKqDwzyQgOi6yhI0BoDwLkwMEE7wHWJxnvaZyqFA1zKEUIGIV0EDCH5aB+bQ0CkDCZDMWFuZ4IOjB5uhX6INx+J4kaiCuRAwYRbesDGfoyA3PaVZRMpCzjs0GL0JZiQonAxF8fUjHOOhJDiLcHkaZc1g+M40S0IocJlM6Ughldx1kHA6FLfhozYP837OMpSAQosyw5LI7zAnwJBlE8rYSA2sZ4np-SGREObAW1STGY1+AsKxyWzGABiMChXxJAkAimSC7wgP4-jCjAzJGlSRoCgA4jAHLkgKzxavI5JM305wRZ5oaHLB55kXAai4PQCwYlUJBIDkUbML1iD7S+fBVpkhBWPa5A7DwRQIOs5Qw-M-AefghBFEcgMeRItw9va-gxH6tm4lypDGZCiCAJgEsCuIYJOGBWjzzDwGKyzmGgU0YpjSxBGDhkuXSIBgRDkDAsT0AO+YRZAuDAfcMAAFbrBMzESFAdaFBIxClO1pRl4we7COhUyxLIzb6PYtEYdQzhR8e3jMKw+4VjgjT7YQKQSCGziz-t4V0MihuweYMCiD2tC1qQOmQ84+hgAsjhN2REKVbOHp7geS6B6cUxwAI2xv8B9hsN7ABQMC+zziZbawdChUQUv9PAAIbAVgvG6PAwxH4PVSOtAGZk0AMFMjLTww47DIlaIoWQgDJiMHENTFEt8963kPrOAU8gmYOy7PEUqlhSGJD9IAgugxoiMB0k4ZwRAMDKW3BcD0aAqKIgvPEasrFaI2HbOOSEpscDmwTg+OO0UeBkX9iA2Ab5xBfgoYwKoogrD1w7A0RAtAWCADICEacZwDQHsU2PgcJ8CzASOhOAKJkAgjzAWIst9BwZzzpCfMTsoqnisFWP4GhrKowMkTGgKQSa-DrD2ZCGh0lsJQBQKgedVBRF2OpFIpiXodh4PmOGJgkBQEqQ8Kigw9E4CKIQM+zgyibDibOKWQD7RbgSIIL+HlgmKGxrOYyRDgnFVULcJI4dZxEEHLgLoF5mQYMpp6MMYBkiwDKeYt2wVrFT0kmRDku0yiyyYFYr8wly7BOLDAAAssstihsqh8KbrcQCl4VFoGuZ+cK2hZCpQLoVEEaByDGEQusWYKEzB1QkBfZAglJFkRkoQOSI5VDOMJEaKAgdriICeMFTwpk0IYXtIoKwoRmD5ANlCHMAwki7XNIMfoiljGNQgjUOwalmyh0KDgKAKzkjnmcKk78JddktD-OhRAbUgFMFyiTCKNx9pgVvLEMolNnAOyqH0AYMRcqYB6EK9wDcKyxDhCkBJhkAjJ1sNs4ZZQNCwF+pgcpbtTqmXeYTB1gwnVpx2fhAeL8hHv3FjspAaxEBFGgBQBuvhiL+EdRLdOobB57EZEaDkTMKzxtgIjb2dqjLALkNIStvZhXeRgAACnxYSlwVhDzKDBLq2Y84ACUic2WIA5UAgOoDZ4MCgH3SIMQ4gJG+Bee6j17Ba1IEUKAA9A3JImN8WG+AFhFERLEKaAR9KGWYn8UwiC-KQmzom48zgmAnR3hWc0ABGAAGiRLkT7NRRvtK62AGILy4FYDK+IGFCAlAIKTe08gzVPhQL6X+v9myrlCGiXFuIMUhPgTAQ13DjH1H3RJEtaayIKoLAwW8zDjI2EcHe24aGkPHBYvWP+qa10k1PAPfMSQzFmC7L8ICS0LznO+KuWj+4yFSpSJx1Q0E7ZuHfIMGOqzpVJnMdUIKtLZYTVKGOmA3sQASB2Uxe60iEI3EQU3Kmpl6A5hareawTxVOWvch1fCFZqXfERtJDWfxgo2EoI0EQJxYAkASHgILFUzz7QALTiGhasfQ4i1KNsYEQFuZA4uSd8XwNsid8IlwcDXJzS6vMpaKt2NisD0WyXkpVlSEU2zjowM-NI6EChdlyeFpOgbkGlqxlCYV1YUDr3uE1lE1z0sggK4-IoTBDYVmTmYRVF5IUVxUXU-pxLFaLti7QeLMDa1lCWVYREgmyJR1uLAIoWrTIXjqEgZSpl-1kTmDEpIpoOLRGrLeA2lV8CEL08jQk8hpYOEQMIQ4sRoX7Qxr8qa5FYrmNUAAfXIDRf0fArD-iLUW50J0Xtdl0-i3evU4OzE9Wpb26zaD7UQdWn1qX1g08qAUKuOcoKPxM0lF0Y2ojaviLtddZBYDFWYdWh8TdHAi3LGRcBbEbsPgvE+AgAbQdnlu9KtsQcJinHODgBZ45VAQQE8oSwN0hXoE82O72zYRIk6aYrU37kKwkDdicCnzsaD2mK2AwLj9HgO4fGl9CxhoCIXFU1lroSuHVlLhWOwJUkALHKn+5QxgMHa3UqOXajggQr2UhgkK3wCrCs9yTQ4UiKdVTKhkLIiJ4HXGU6QWeGAigyLmv8v0xO3EIMrdISAaFxKVOQB862Qur5TW15dHrsA8qy0AuFQ24ZuyVSRjxPEpFHD3VpaWPss5Ol1i+sBNwSylgwHTzT0ynkCiMPmPYbji1kB-GEXLnF6lUQXV38OZwYiw5uC5zpuFCOCgIHDfsRI4u6pjuDocEsiKnEMvDlGXkYLyienAV0AQthhBMiFUKHuIEkAOD2MIJ6IOKQLASshDBjlgE0nVuiFCjClpLPCLsKistXsAFRDRLtDfJ1GlvUHADMnDvdNYKbIcCBmAZbkkLLA8GUHYBNOHmhuaDSmELDlwReHwX8F0JcqUIIUwH6MAIjnWCjpQFAMjg1GIP8igBwGvqNISO8BgNELEFtrDnzlOrtOMN5NIL-EAA";
    static String inheritanceText = "jgEHUBYIYC4AQMYQHYwJ4HsCuMoFMA2eMAtjjBAEaaxRgCWAzjAOYQkD8guAQA0qmZ9Aax4AHNHlq48KAHQwYAeQBm8TACd6OHuiwDEaAO4wcANxyqUNWoibYwZ0g2xoYug2UoZqdRixKyAogCOGBAEKFp8GIgAJmb0UEjRttC2pPTBEPoCVjZMGAQw5DiKaKqk2jwQxBAI5GXEtAAeMGjKoYTaqi14SYqqtDgx9DwIyHqwNVAhYTD0EChkiBZ01jAYGor5hTUCsgBCnqn1EPX0aCS2OYxoiGm0RMJSMAAi8v4AypUxs8I4ENmrKDOTrwSCqJg4RhFEr1RRmcw5VJEGCOG6kVpI6QAHjqAD4capccB3gBFEAAQRAAGkAIR0ukwACqADUYCB3gAZAASAC0OTAAHJcgAq-J55OZIBgPK5AGF+XseTAAEoABXe7xgiulEql5PkqqVAEk9gBNABiWp59Lp3FSTlUJEQuCSeQK9DA-RwAnoshgpr4emiPBomCYYCgmzC2LxBNxyr+4igC0U4mEvrjcYDGC6cFoqjgGAkjA0OGRQNmcFUrHIeBwskzeOzZH0J0GkKheDQ9DOREYwgg8UYNFI4iIEjixD+zqcLhwOGEvCwmTbLWUNyeaOw93wVk0iySG4WoY0LWQI5g-XDsHotFia-tIHafubZVCtAAXqQL-JyBpVKY6gwJApgqM6qhiHWSQgiYZgLJMtA3DwGCLlEUC0IQej6LIApuNoZCwmU9YwMKdgwMAexoFAHCFJ4QLII4egwF21hmE4TBMFBMaEnGpGkL+-6AYwIGkJMODRLIfEwOSBTmtAdhdI4cCQKxEkkQpDiMExrYLP4+a0AIXTRGgkIwOMLhYZcvpyI2hLNnUAypgsrbxN+O4wPoDArDYILCBBTDVkQ46rO0BjiUus6Fuo+7kIcIKym+QKqDwzyQgOi6yhI0BoDwLkwMEE7wHWJxnvaZyqFA1zKEUIGIV0EDCH5aB+bQ0CkDCZDMWFuZ4IOjB5uhX6INx+J4kaiCuRAwYRbesDGfoyA3PaVZRMpCzjs0GL0JZiQonAxF8fUjHOOhJDiLcHkaZc1g+M40S0IocJlM6Ughldx1kHA6FLfhozYP837OMpSAQosyw5LI7zAnwJBlE8rYSA2sZ4np-SGREObAW1STGY1+AsKxyWzGABiMChXxJAkAimSC7wgP4-jCjAzJGlSRoCgA4jAHLkgKzxavI5JM305wRZ5oaHLB55kXAai4PQCwYlUJBIDkUbML1iD7S+fBVpkhBWPa5A7DwRQIOs5Qw-M-AefghBFEcgMeRItw9va-gxH6tm4lypDGZCiCAJgEsCuIYJOGBWjzzDwGKyzmGgU0YpjSxBGDhkuXSIBgRDkDAsT0AO+YRZAuDAfcMAAFbrBMzESFAdaFBIxClO1pRl4we7COhUyxLIzb6PYtEYdQzhR8e3jMKw+4VjgjT7YQKQSCGziz-t4V0MihuweYMCiD2tC1qQOmQ84+hgAsjhN2REKVbOHp7geS6B6cUxwAI2xv8B9hsN7ABQMC+zziZbawdChUQUv9PAAIbAVgvG6PAwxH4PVSOtAGZk0AMFMjLTww47DIlaIoWQgDJiMHENTFEt8963kPrOAU8gmYOy7PEUqlhSGJD9IAgugxoiMB0k4ZwRAMDKW3BcD0aAqKIgvPEasrFaI2HbOOSEpscDmwTg+OO0UeBkX9iA2Ab5xBfgoYwKoogrD1w7A0RAtAWCADICEacZwDQHsU2PgcJ8CzASOhOAKJkAgjzAWIst9BwZzzpCfMTsoqnisFWP4GhrKowMkTGgKQSa-DrD2ZCGh0lsJQBQKgedVBRF2OpFIpiXodh4PmOGJgkBQEqQ8Kigw9E4CKIQM+zgyibDibOKWQD7RbgSIIL+HlgmKGxrOYyRDgnFVULcJI4dZxEEHLgLoF5mQYMpp6MMYBkiwDKeYt2wVrFT0kmRDku0yiyyYFYr8wly7BOLDAAAssstihsqh8KbrcQCl4VFoGuZ+cK2hZCpQLoVEEaByDGEQusWYKEzB1QkBfZAglJFkRkoQOSI5VDOLsnwSwiB355MOAs-Z2SKFY2MQUIogxZDgAWPdJIoL0pgOxdUaBnUIKUC8UVLcGIEmGRRMofCA96hMAwYCZwYyMJgx0tZPiCx6ArXIEUJIcBirIHaA+AVqhA7CVKP0GhqZMiIKmLMoFfAzEnTIneRMXVDAIFcrMMwxhal90DNvSB79jafwrCCeg8L+ilEYAACjPrQYRjht7oFuAASgxnnDC1imlPF+KoGEyIQQQTrInfCq5VqxJyE8LsuTCCwLIu8OsC5ETvDML8Z0b1SBYogbtJ54C2IYgxThPlyhkmwDyrElMbdmUNQmTlQoKiIAWwfAssRb8i0phKiLcsJMomxFCIwHV2BClPAYH6DkE5qwzGCWcJawSyInH6KYQ8yAJ7nJiDwasbLkmap7NnREE8xnOmWRG0J8QrALG0TIolXVYBbTQNEKou0RzIAHD2cK+T3m7wwNEaIDcMQTwMMgaIEExB+n9PIRktt6gXgGSdHMt7HCUEXs6ZwHyIDiuGgRojorvxkTIxOpghtLmFIkIieB1lTSEeI2x9EF0KwkBwBMb40IvTfBDbtANf4cDBBTQsIoABaBRKBY0wHNIMfoOKYDeyhri3E9KzP0pRJu-SgqKANwrDUWWDxxAekuikX6SBxh0vPtZ4Z9mnbFBhAc+gTwigpFYcxXa+ERK70wDEC1mMSAJAIL+uwU0yAsCsMwjqZ8UhuIQbXchA9vTWTZL51jEVem3HEuFZBnmxhUT6U3WKsAZaYB6GZrdFtcGkGFIU0gqpuoPnWXeR+sQ6zyz0wZouy6jCNAYLgLWolvjFVMBmZGeLlzHBYvWb2zZVwUESGiCS+3LWIAUk3C8UABtTlVqsDExgNmP1XFU-ANTnRIx4niX+QA";
    static String gigglesnortText = "jgEHUBYIYC4AQMYQHYwJ4HsCuMoFMA2eMAtjjBAEaaxRgCWAzjAOYQkD8guAQA0qmZ9Aax4AHNHlq48KAHQwYAeQBm8TACd6OHuiwDEaAO4wcANxyqUNWoibYwZ0g2xoYug2UoZqdRixKyAogCOGBAEKFp8GIgAJmb0UEjRttC2pPTBEPoCVjZMGAQw5DiKaKqk2jwQxBAI5GXEtAAeMGjKoYTaqi14SYqqtDgx9DwIyHqwNVAhYTD0EChkiBZ01jAYGor5hTUCsgBCnqn1EPX0aCS2OYxoiGm0RMJSMAAi8v4AypUxs8I4ENmrKDOTrwSCqJg4RhFEr1RRmcw5VJEGCOG6kVpI6QAHjqAD4capccB3gBFEAAQRAAGkAIR0ukwACqADUYCB3gAZAASAC0OTAAHJcgAq-J55OZIBgPK5AGF+XseTAAEoABXe7xgiulEql5PkqqVAEk9gBNABiWp59Lp3FSTlUJEQuCSeQK9DA-RwAnoshgpr4emiPBomCYYCgmzC2LxBNxyr+4igC0U4mEvrjcYDGC6cFoqjgGAkjA0OGRQNmcFUrHIeBwskzeOzZH0J0GkKheDQ9DOREYwgg8UYNFI4iIEjixD+zqcLhwOGEvCwmTbLWUNyeaOw93wVk0iySG4WoY0LWQI5g-XDsHotFia-tIHafubZVCtAAXqQL-JyBpVKY6gwJApgqM6qhiHWSQgiYZgLJMtA3DwGCLlEUC0IQej6LIApuNoZCwmU9YwMKdgwMAexoFAHCFJ4QLII4egwF21hmE4TBMFBMaEnGpGkL+-6AYwIGkJMODRLIfEwOSBTmtAdhdI4cCQKxEkkQpDiMExrYLP4+a0AIXTRGgkIwOMLhYZcvpyI2hLNnUAypgsrbxN+O4wPoDArDYILCBBTDVkQ46rO0BjiUus6Fuo+7kIcIKym+QKqDwzyQgOi6yhI0BoDwLkwMEE7wHWJxnvaZyqFA1zKEUIGIV0EDCH5aB+bQ0CkDCZDMWFuZ4IOjB5uhX6INx+J4kaiCuRAwYRbesDGfoyA3PaVZRMpCzjs0GL0JZiQonAxF8fUjHOOhJDiLcHkaZc1g+M40S0IocJlM6Ughldx1kHA6FLfhozYP837OMpSAQosyw5LI7zAnwJBlE8rYSA2sZ4np-SGREObAW1STGY1+AsKxyWzGABiMChXxJAkAimSC7wgP4-jCjAzJGlSRoCgA4jAHLkgKzxavI5JM305wRZ5oaHLB55kXAai4PQCwYlUJBIDkUbML1iD7S+fBVpkhBWPa5A7DwRQIOs5Qw-M-AefghBFEcgMeRItw9va-gxH6tm4lypDGZCiCAJgEsCuIYJOGBWjzzDwGKyzmGgU0YpjSxBGDhkuXSIBgRDkDAsT0AO+YRZAuDAfcMAAFbrBMzESFAdaFBIxClO1pRl4we7COhUyxLIzb6PYtEYdQzhR8e3jMKw+4VjgjT7YQKQSCGziz-t4V0MihuweYMCiD2tC1qQOmQ84+hgAsjhN2REKVbOHp7geS6B6cUxwAI2xv8B9hsN7ABQMC+zziZbawdChUQUv9PAAIbAVgvG6PAwxH4PVSOtAGZk0AMFMjLTww47DIlaIoWQgDJiMHENTFEt8963kPrOAU8gmYOy7PEUqlhSGJD9IAgugxoiMB0k4ZwRAMDKW3BcD0aAqKIgvPEasrFaI2HbOOSEpscDmwTg+OO0UeBkX9iA2Ab5xBfgoYwKoogrD1w7A0RAtAWCADICEacZwDQHsU2PgcJ8CzASOhOAKJkAgjzAWIst9BwZzzpCfMTsoqnisFWP4GhrKowMkTGgKQSa-DrD2ZCGh0lsJQBQKgedVBRF2OpFIpiXodh4PmOGJgkBQEqQ8Kigw9E4CKIQM+zgyibDibOKWQD7RbgSIIL+HlgmKGxrOYyRDgnFVULcJI4dZxEEHLgLoF5mQYMpp6MMYBkiwDKeYt2wVrFT0kmRDku0yiyyYFYr8wly7BOLDAAAssstihsqh8KbrcQCl4VFoGuZ+cK2hZCpQLoVEEaByDGEQusWYKEzB1QkBfZAglJFkRkoQOSI5VDOMJL-U08hGQAHJlT+EFPQ6SHJ5ACn8DwAlxLSXkqZkaZUpKOT+GZLzJm9KSVkroUzGAcY5DCuFeSKlNK6WEt5UymALK2Ucq5SKoVIr-RSsZfyyl1LaWqoZXyilcr-Dss5QKblaq9VMzFVqyVuqZVxgNUaxVPL1UUstRKnV0qNX2oVSa91zqLXirJTZPEKqYDWo9fq1lhqFVBsJCGwUpqbUatddqp15rZWRodT61NMrk1hr9em+VxqE3hv9Va31aavVFvLTmgNPA43CuzZ6jNgblUqqrY2l1tbq1NsLY6s1Nay0duZc29tcZ+1JqpYK4Nca3VDoLVG419aSLds7YO8dEbe1ZvXaW2d2752ZuLfm3NK7h2bsPWm49MbcRxrnZWvtibV27ofTulNaq4wVpHfektV763HtvZ+rdz7NVPu-XewD36-39sg0BsD56B0gfzbBk9wHX0wYA3Bida60NnuQ9B0D6HcNdv-cqH9IaF1fqPURvdSG514cQwR2jVHsPkfA5RrD+H5VxnbXuujH6cOMfY-R-jPGmMcZYxhx9qGSWkZVXx8T76D2EcE3JmTIrFONrHS+vNcn1MieUzKmjemEM6e9RJrTyHDNAd4wZhjaqVWtvjUp4zNnhNWdE0J8TTmpMed025-TPbPMCecwF3zEH3Mme41Zpd4WXOBaM95iLFGL0xYC3GULbHgsbri35zLp7yNxmY+l5L-mstFfgwl2LZXMO5f3aZrz2nKt1aCxVkLTX4sNdU3IYj2Wwslby1VyTDXWuRd6zVyzo2WtZbS21nLk3+szYm0N0rC2MtzdqyN1bS35sbeK2N2zs2tvraS+Vw743NsWf24ti7rmrvdYG+Zu7K2l27bW2dl7p3Lvnceztk712etfeoyO4VDm5ApeWz96rr3Pvvb+-dlDH2bsA8KytmH33juQ4R-91HgPEfY+RxDwbsOUe-ce++gnD2cdY5J5TuH1nhvo8J2j1jIORW49+8D6dIqmdmfh0T8nvPuf1b5wzin+ORcC5p8TjHwvWMXs0xLsXW6Cu3cl-zun4Pxfq+25rsH2vZfU4Ze+xravdeyqXdDg3Ynaem7e5bnzUvGeq5131o7+vpfc9-kaKAgdrgCHmLII0zAcBeBSNoZ+7VCnSOxn6I0gdkQACkSO7Vj8iJgGDAQr0aFHQ2CyKxvk2aQMozCMSsI8aUGQf9-A1B2b1FAbzjEiN3LcWQGKCLfkKTFQ4Z9aDCMcBeIg3ZYCAAwCapxhamBxRA3pZUAVkPl8nEX4X1aCmEqboihP9kZ4vJN8WOag1EHHMaoSisBHArnqCXvBZACA8D+MI3a28Fi3msA3U6TfNK716nkREG8A+wC5OSTUCsB2UvHSROQPNxQgfRJ4Y2XoNuDeU2Q4GWJAUBBIKBWcASMwISNYRAbJM3YyChPuPgdoeAJAQoBwFFARJABYe6R6ewGcV-c6UyCARQWfZ8NkEuFEZQXsdEZQfCESIOPZHMB6AYJIAUO8EmDiVAYPNgBQIyO8ChWiWAI8MgFgtiMeREKoLsJQ5QKlJ5IWGQ+QeqY4PAfPBYdQwEM5axCMbmZPLGZOUBJZe8OvKANgX+b2KGBQyASmZwRhAyb8CeWw1JS2LAKIWIdQBIT2GANwzfXEQPLwiZZwYg5JG8AcZEaEFuWcG+WcC8SgGfUWDSHgMZLoQYbZHxe0Bgh+ZIiKOOHoX5KaKybAWeKAP0KdHiPET3b3LSKiTqAKP4QQj8D8OsSpZQFPZgZfREfCD5a2fJK8awrCBA2AQPVsZ0cKC8EcEgKqFoP8KKJFR+Co12WcXwlZdoBYOgcMcQa8deewJGNovFWUcQT+C8EoAgAwREfQUoHhWcYwDZFoQ4NYncRgxgMoPySEJpcKcgceMsAALhsgLlIPkIAF4YA+gBgYhcRzRlQjR-A+YsQAB6OExAXEHgLEAklEJIJEyFQSMwXEeQPYd4fwZUZkBkvEgkokkkgcBickr+fMa9dmLkBko0YUXmWUfwFkjkokwVUkxEsYjidJPQCqXEDmI0DmDmdld4OhZUYUBsfE8Uq9BxEuEFeQ-CSwRAd+WPHGCCRcC8b4+Q9Yo+OwZAAecPK-Uwho2IBcMoiQGQ0iS+XBUgbhREDqKoDmIse8DEdZO8QgrAUYUBe+C6TQqwpQ50E6QpGgKMkgxaHAhYMoAfUCKo7vYRfCfA8yZY5ouQbfJIJYzAHoAQowRoSYJ4S5c4J0SmSPdCEKJYLcdpIqCAe4P0hYWUXmYmB+BM68FhVMsAWQDkRMjM2uYiX+IAA";

    static List<String> happyHellos = <String>["BORK!!!!!","HI HI HI we are FRIENDS!!!!!","ITS YOU ITS YOU ITS YOU ITS YOU ITS YOU!!!!","treat????? TREAT!!!!!","you're so good!!!! way better than the REAL guide!!!!!"];
    static List<String> neutralHellos = <String>["BORK!!!!!","FRIEND?????","!!!!! a friend?????  A FRIEND!!!!!"];
    static List<String> angryHellos = <String>["BORK!!!!!","GRRRR!!!!!","go AWAY!!!!!"];
    //bork goes with everything, add things to these sections based on stats
    static List<String> _happyPhrases = <String>["BORK!!!!!","my WHOLE BODY is a big TAIL and I am WAGGING it for my FRIEND!!!!!","BEST FRIEND I WISH I HAD MORE THAN BUGS TO FEED YOU!!!!!","i wish i HADNT EATEN ALL THE NOT-BUGS so you could have some GOOD CRUNCH!!!!!"];
    static List<String> _neutralPhrases = <String>["BORK!!!!!","boy these CHAINS get REALLY REALLY REALLY REALLY REALLY cold here!!!!!"];
    static List<String> _angryPhrases = <String>["BORK!!!!!","GRRRR!!!!!","i HATE you!!!!!","you're BAD and UNIMPORTANT and FAKE and NO ONE LIKES YOU!!!!!","you can't just TAKE THEM AWAY FROM ME!!!!!","put them BACK!!!!! they aren't HAPPY in the GROUND!!!!!","You're just a FAKE GUIDE!!!!! You aren't IMPORTANT and you can't BEAT ME!!!!!","BORK BORK BORK BORK BORK!!!!!","you're FAKE and UNIMPORTANT and IRRELEVANT and NONE OF THIS EVEN MATTERS!!!!","you aren't a REAL player!!!!!"];

    //add specific things to this on the fly
    static List<String> get happyPhrases {
        GameStats gs = Game.instance.gameStats;
        List<String> ret = new List.from(_happyPhrases);
        if(gs.helplessBugsKilled > 13) {
            ret.add("CRUNCH CRUNCH CRUNCH CRUNCH CRUNCH goes bugs!!!!!");
            //ret.add("");
            ret.add("BEST FRIEND likes crunching BUGS too!!!!!");
            ret.add("BUGS are so CRUNCHY and BEST FRIEND gets it!!!!!");
            ret.add("give me the CRONCH and i'm yours forever!!!!!");
        }else {
            ret.add("BEST FRIEND BEST FRIEND you HAVE to try BUG CRUNCHING sometime!!!!!");
        }
        return ret;
    }

    //layer them.
    static void printText(Element container){
        List<Node>children = new List<Node>.from(container.children);
        children.forEach((Node child) {
            child.remove();
        });
        DivElement me = DivElement()..classes.add("ending");
        container.append(me);
        String ft = LZString.decompressFromEncodedURIComponent(friendText);
        String ot = LZString.decompressFromEncodedURIComponent(observerText);
        String ht = LZString.decompressFromEncodedURIComponent(inheritanceText);
        String gt = LZString.decompressFromEncodedURIComponent(gigglesnortText);

        DivElement friend = new DivElement()..setInnerHtml("<h1>Friend</h1><img src = 'images/ButlerPanel.png'><br>$ft<br><br>Want to Learn More about YNBot? <a target = 'blank' href = 'http://farragofiction.com/ABEmail'>AB's Email: knucklesisgross@gmail.com, Passphrase: dodge_this_moist_pimp</a> or <a target = 'blank' href = 'https://archiveofourown.org/chapters/50697950?show_comments=true&view_full_work=false#comment_260804131'>ynBot's a03</a>", treeSanitizer: NodeTreeSanitizer.trusted)..classes.add("story");
        DivElement observer = new DivElement()..setInnerHtml("<h1>Observer</h1><img src = 'images/ButlerPanel.png'><br>$ot <br><a target = 'blank' href = 'http://farragofiction.com/AudioLogs/?passPhrase=butler_b'>AudioLogs</a>", treeSanitizer: NodeTreeSanitizer.trusted)..classes.add("story");
        DivElement heir = new DivElement()..setInnerHtml("<h1>Inheritance</h1><img src = 'images/ButlerPanel.png'><br>$ht", treeSanitizer: NodeTreeSanitizer.trusted)..classes.add("story");
        DivElement gigglesnort = new DivElement()..setInnerHtml("<h1>Gigglesnort</h1><img src = 'images/glitchButler.png'><br>$gt <br><br>WARNING: IF YOU VOID OUT GIGGLESNORT YOU VOID OUT YOUR ABILITY TO CONTROL WITHOUT WASTING. But. Of course. You need to see the text. I'm not going to just give you the answer to this puzzle with no work now, am I ;) ;) ;)<br><br> Besides, it'll be easy to get back here if you have to refresh the page. Actually, hold on, let me help you real quick. This might be a more interesting way to refresh the page: <a href = 'index.html?seerOfVoid=true'>Seer of Void</a>. I'd highly recomend using it to replay the game, see what sorts of things you might of missed. Nothing important, of course. You don't put RELEVANT things in the void, those things belong in the spotlight. Even if you can't trust them. ")..classes.add("story");

        me.append(friend);
        me.append(observer);
        me.append(heir);
        me.append(gigglesnort);
        querySelector("#friend").onClick.listen((Event e) {
            if(!friend.classes.contains("void")){
             friend.classes.add("void");
            }else{
                friend.classes.remove("void");
            }
            window.scrollTo(0,0);
        });

        querySelector("#heir").onClick.listen((Event e) {
            if(!heir.classes.contains("void")){
                heir.classes.add("void");
            }else{
                heir.classes.remove("void");
            }
            window.scrollTo(0,0);
        });

        querySelector("#observer").onClick.listen((Event e) {
            if(!observer.classes.contains("void")){
                observer.classes.add("void");
            }else{
                observer.classes.remove("void");
            }
            window.scrollTo(0,0);
        });

        querySelector("#gigglesnort").onClick.listen((Event e) {
            if(!gigglesnort.classes.contains("void")){
                gigglesnort.classes.add("void");
            }else{
                gigglesnort.classes.remove("void");
            }
            window.scrollTo(0,0);
        });

    }

    static void amaglamationMode(Element container) {
        DivElement me = DivElement()..classes.add("amalgamationPopup");
        dynamic listener;
        SoundControl.instance.playMusic("Noirsong_Distorted");
        listener = window.onMouseDown.listen((Event e) {
            SoundControl.instance.playMusic("Noirsong_Distorted");
            listener.cancel();
        });
        container.append(me);
        String rantings = "<br><br> What?????<br>WHAT!!!!!?????<br>you YOU you KILLED them ALL!!!!!!?????<br>no no no no no no<br>they were MINE!!!!!<br>you aren't a REAL player!!!!!<br>you can't DO THIS!!!!!<br>i won't LET you!!!!!<br>I WILL just KEEP bringing THEM BACK!!!!!<br>just like i did AFTER MY CRUNCHIES!!!!!<br>its not MY FAULT they got extra CRUNCHY after I CRUNCHED them!!!!!<br>I GAVE them those sheets!!!!!<br>So they wouldn't HAVE to NOTICE they were extra CRUNCHY!!!!!<br>its NOT MY FAULT!!!!!<br>AND I WON'T LET YOU HAVE THEM ANYMORE!!!!!<br>Because because because YOU CAN'T BURY THEM ALL AGAIN!!!!!<br>If there are as  MANY OF THEM AS I WANT!!!!!<br>I won’t just take their LAZY SLEEPY GROUND NAPPY TIMES AWAY FROM THEM!!!!!<br>they are MINE and YOU CAN'T HAVE THEM!!!!!!<br>their IDENTITIES are MINE and now you can never BURY THEM AGAIN!!!!!<br><br>";
        DivElement text = new DivElement()..setInnerHtml(rantings)..classes.add("amagalmation");
        ImageElement reveal = new ImageElement(src: "images/Seagulls/bones.png");
        me.append(reveal);
        ImageElement angry = new ImageElement(src: "images/Enemies/scarywolfhead.gif")..classes.add("scarywolfhead");
        me.append(text);
        me.append(angry);
        Game.instance.beginAmalgamatesMode();
        me.onClick.listen((MouseEvent e) {
            me.remove();
            Game.instance.startOver(Game.instance.currentLocation);
        });
    }



    //add specific things to this on the fly
    static List<String> get neutralPhrases {
        GameStats gs = Game.instance.gameStats;
        List<String> ret = new List.from(_neutralPhrases);
        if(gs.helplessBugsKilled <= 13) {
            ret.add("????? you don't like BUG CRUNCHING??????");
        }
        return ret;
    }

    //add specific things to this on the fly
    static List<String> get angryPhrases {
        GameStats gs = Game.instance.gameStats;
        List<String> ret = new List.from(_angryPhrases);
        if(gs.helplessBugsKilled == 0) {
            ret.add("MEANIE!!!!! you won't crunch stupid bugs but you WILL HURT MY FRIENDS?????");
        }
        for(Tombstone t in gs.theDead) {
            if(t.npcName.contains("Ebony")) ret.add("SPOOKY FRIEND was my FRIEND and she WANTED TO BE CRUNCHED!!!!!");
            if(t.npcName.contains("Skol")) ret.add("BORK FRIEND understood how TASTY BIRDS are!!!!!");
            if(t.npcName.contains("Roger")) ret.add("LAW FRIEND could tell you!!!!! I didn't break ANY laws!!!!!");
            if(t.npcName.contains("Halja")) ret.add("SMUG FRIEND was the ONLY ONE who UNDERSTOOD ME and you BURIED HER!!!!!");
            if(t.npcName.contains("Kid")) ret.add("COWBOY FRIEND knew I was a LITTLE DOGGY and you TOOK HIM FROM ME!!!!!");
        }

        if(gs.theDead.length >=5) {
            ret.add("they are MY friends not YOURS!!!!! I'm the one who brought them back!!!!!");
            ret.add("of COURSE they are my FRIENDS!!!!! I SAID I was SORRY!!!!!");
            ret.add("It's not my FAULT they looked TASTY!!!!! and I BROUGHT THEM BACK so they can't be ANGRY at me!!!!!");
        }
        return ret;
    }

    static void wakeUP(Element container) {
        print("i'm waking up");
        if(deleted) {
            printText(container);
        }else {
            attachFenrir();
            sayHello(container);
            int time = new Random().nextIntRange(1000, 10000);
            gullsGratitude(container);
            new Timer(new Duration(milliseconds: time), () =>
                beChatty(container));
        }
    }

    //Grab a brush and put a little (makeup)
    static void attachFenrir() {
        if(fenrirElement == null) {
            fenrirElement = new TextAreaElement()
                ..classes.add("void")
                ..id="GoodBoiDontDeletePlz"
                ..text = "Fenrir_DataString:___ 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-AoFOLCBQviFBgF8JTWoEB-EdmEhUSClQ8wSCySkKAVhthKDEHiwYfycAyHyF0I07ooC1FqFtNo-h0BWCgIUFZwhth2zUFAZUmVah0AsDgY0HAwA0nyB4h5ag8juGHEYDgMg8yFD0F0EwQoaVkwEPkVYIKuhGGzIKfwchqjbG-O4LQCQUgJC6MXdAhQtAVE0UNIg5QXKhHNhANlwgTBWBniYEuLQjAoHcBwwYgKjpGDfJkJ8YhVj+CMEYDpcgjQyBQJhV66QxBdBIAoLM9stDmF8NiOk1QJz+B4SgI01sjBw0-PkT8+9MBECUEYNogpBRkGjuy3wFYShGkFBwMFAhYQqBpL4Z4qwzCnAkIUTAXR-AWBuTSFwMgcgnBqW0TI7hQRQiIDdVarAxpEDaNQZ4ZhICCi6AkOQJQoASEGBIEoJhngwFYBSI0LhSUwEGHQJ6YAxChAkEoQobJhACEiA8MwtQuBWAgAoOWviBDpC4HoCoHyupKFOHmPIegcgmgsJNZ4eYbhXkiKcbY9GIZqG7cITBKRMAUdOB5ZDEMcgfjoIZDgjSQwGApIUvMpwZBcAqGQHAbQzMpMyBaWyCgGEpDWoSsg1BnQqEwNQQYRBVhtC4FkqwCQKTxLkDSTAsoCpdCIBYMQPCIBIBMHmGQoQuiRAVChmQ6A33bDLRSLo+QKghi4HJdwmWVBtpkKwYlXAJBkCIEaOQhR-CqxMEQBrtQoAUlOGAagKA7hQDEMFJQNJTgw1qDSTI3oYDPByJkOwSAwBJjcBSNolWGGClqLMaW1BWA5BpCoc0d0jQlH8P4Z4kAwvoMKDgdwtQjRtBcCUBQKgBDKAkDScJBUTByCQGeGQGgaT+COEYQhdA5AmBwIKSB8MJKZAsWQBIVhIdqDWiUMgZBGyRG6WQDhMgEj5CUKsBlRAUgSCQAIHw1A57jYBvEroWnL7ZxwKcdCb0oDgzUKEAaEg1hGjEBSLQpwtB7JkBUPMeZBRloSJgfwJhuoWF8CgbYXRag4A0CQTAvgJDoASEoXwAgjQ0nYxIQU3ZChvoAgS-wW4aSRCMP4SI1B3CYDENsB+1WwBkBgBlsQuOKPUFODJfoRiap5QJnmCoW1BRaDyC4fw2WjADDaGQCAZg7vbC0EmCkOAKhcB6zANqqCPxEncHgzd1RgoNZpKwKAdBViyZSBUHK6r-AGOM0cBXgwaWREkQIIwIsmIoC4DIdrAg6C1FhHICbZgJCBBMBICQZEzAcFbGFkhehtjUDUCoNnJAIVriynaVgAgXBlLEGoLoZgVCNRcHQFZSh0C8PSJEdIRouBaEwIUFgcDFQCBpCWohKgUIZgJQUyMEUA6AYgkQHA-kmYVgAMcgYAcg7gZgWmMogwrocgwBhQxu1ArCZAtQkQB0Ro5U6AiGAmAoSgOCJAMAFQvgLCAgZgZgMAFUFQRoHAoQ8shQ1QYgKgmQRgf0GopCTwPoagJASgLg1ARgrARo4uk6WmseJgZAVgYgMMzw8wZogoKAkQgwZAbQ6AcgOAFgEiegZAAwusKAv0+QWUx8egaga4jQSAZgSARWPc6AYQmQKQ3MOQXAlMOQ7g+u5sf0bQfySA-ghQpwvUdUsoKAd4Gg7gSARADglQOAageYMARw4a6QJQiCSg0qg+ZUWg+Q3QgoxGRAvgvgFmVgTqAs9+swOA-iOACafUugNIrCJgKQ6gSAYi-2IKEg4BxqtQXQ3KGuKggwqw2wLgaghQagRg6Qza-ghwcgqwxwiQ1QdARgBsMAXQH4JgagCQZK6KbQdAYA+26ACgWg7gKAvg1AVgGgP6-Qlg38eGa6RghMKgPmYA7gvQzUSg1AJAbaXAkQXMyU9IbQvx7gkhkQKQJ4exYAXQUAcggKmAZAHAahNIbsTc7WN6MUl66QFIryagR4Tiy004hsQc30zwgwFIc+Kgd4+yGgQyFIagKAagLgFgLg+QJQRAagdASg-gYAJACk02SgV6FgwgYAVhVqpwRgCguI34XA-8S+cg6QPUeY-g7Glg-sCQUWEAqwPaAgRxRgSqCgp4kQcg0kEEwgJoRAhiPowgkQMWkQlKeY4xqwFIZK+QtQSAkQOALg7gBhCpfM80ywOA-gGQRo5MDUb4MgagNiro3CTQVgZ8gobQRIukfU1ASAGQKQgkEgtQ6A6Q4uLgCQdAGoXQeY6AMARY8EE4SAvgyMHARgFggwNIXAJaZAMgZA2wJQKgSANST+EA+UOAm8qYDAHUYMF+pwdONs02HsVgbsYgOAkQGgmAqwWgMkLkCQWgEA6ELg2wvgjmFIuoeYEA-IkQSAag2wn4fpVezwcgLgtxCQPgo0CQkh8WCQa0CQ5+Xm6AFghQZmKQrA0BYAPsvomAegYgYOOArApwZCZAagSkHsOANIJQd0oQFIXARiVSRA1AcgaqOQFCo+ZcY8JgwYakOQKgrAEgjG846QKgVqrABZDBHAR4+QWhCQ7mMgisJEgxiJu2YpYA+U2wzw2hqKS8Aggowgi5XkYubQYAVg6AJQ4IuR6QSsFQYAYGuy6QZMFEgocgGg-Q1QFId6omRgMgUqSgKAegpkmQbG1AWAZAFQFgCJoqASzwKA58egAYUAHAM2Kg6AegYJpApmGgKQlEjudhSGHAGgwSmFSAe2RA6A6J6OuYJgRg2w-ggoXAtQVwUEFgMAKgqF4OFgOE-g4MERLktyB6h0pwRiWMRgmAL0egXAJgLg-EGKMAhRUAu+SS6FYgYADoWgLgOAgxeYGUfY-w4iwgN06Q1AdASACQga-gKQgwQSZahQbBKgtQqIVgZASACgHAyEDSpAO4goMg+5NIoOPkmQAgagSAeYJiGgzSrZbYBm9RUJj0OAkIrA+QmAGEmAOAfBmQoQlIZpCqgoFIFiYaEmqqXmwgOCdAxi1xpwXuJgoQuOvU6Q2wX4ZACcayCg7RFQ3SRg1AtQMWkIyuMgnERg5OAQqwCpgwryA8SsPWSgAxxigIukZYMWeY1xgwpwAgEJENmAZgSgCgsASAyhz8+geY556ApwgohQ2wrIZAqwZAeYYAZxKgKgdAEMJwwg3kF6gJTcvAHkYAhsEMtYSgVgdwcKSm6ATlkQSUXAU2-oYgIQ7g1BXQ1AOQqG6AZCgBDCpwKQy8kiuI0uYAKiHWqwdAkU2R7RW5JQGgCQH6baNCM8dAmEmWMcFIZAvUUAOAeYLgU5ZAia9FDB1Q8y6OLgWR1QyBronEysJQ7g+QXyMggwOAqwwgZgzg24EAEALgdiQq7g7gSWM87gDCThHliY8ROiqwpwPUGIF5RAwgpM0GKQD1jC91D+6wCgHlSeZIV47gsu2wuESgI02ItQYAvy6BJQiQX1MgkQTSoRKd7SOQKsEpoQtqJg7gQSbg2wFgEAb4EkOQvaZgUAr5+eNGtQmAp5AkUAeqiU2+AgEgC8uOKAN6rA7ghicwZg6Aqw486BP1seTly2uEx6Oeiq1QFyUodKzw2w2whQqwVM1AwgSgiQY2egBNXQ7g6QKA9m6qZGR51AsapwmQEgmOp8JQ+Q60pMkQZg5UX0JIuQCg1Q4Yl9oQAgvg1K-pVgzARdoQXAqwtSySCBagUWw2goEgTlgoRobo-k1ox2CQyw3hgwZs8gFQtSZs4azwLgZgRA6g1Q-ooRxyfyKKJgJgMAfqwgVKOAZg7t8ONMYuHhNIX0kQHYKQzBz4JgX5JQxlRAXQeKhQZlKAhQWZCQWusECqPsbB9NOQEEJQMTMxJhUkpw1AJQsy3djhXQzwF6cC-gEg+G1QSKFGOQ0cFgAgFQlFXQLZvDhQnCYAkQRoXRoQHi+BmQJg+ERoagqwTZpgmQFCjCMAvc8EKg8USSGuegM4agLV6A7IrA88FgqwdeGFdA2wMYxzp4EAqsnkdgu1dAOQCgXsv0pwoQBIbQtQFgEFr+aIhMK9yWGqzYrmCgio6QJg-geYagag1wc6oQ1AWguaMAEDvgSAza1QCUhSVgOAcg8YP6MgZ1qwI1Eg4ucCs4Iq5xUAGwJAqipGbQYgdAMgTw6AwzXQZG480FaqHROCgoEAX5N1rASAUAJQFRHdUU2wlKksQ6Jgn8ZG7g01Agc1N+aAAgtQATWALAJEea1AVEqwFg+QSVgoRgwoLZl0uV5Lmjcg8OeggzkzmQogd4guCuLk59ngALQLWgNICQ5AfmSAoQwgrYCeZsXJVgAc3GWgRAZRd9duEwYCysIF1QDYRoCQbaKAA9h6mA-k1QrGOc4FCQ-gbOQLYgDVRGMgxxP8uWfDJA1ASgrAwzyW2yNIyMYg7JmZmjXWbEAuGojh0e6ABQcgKQGgXAoQdSS8+QJLCgiwOQahI6KQWguQHA8FsCzzRALgKgkdcgwGiGoQsMuhiN2QJQrUYwPkYVii1CEghhmBMQ8KesFIqcrAVu0kdOcgeYYWrAvgRothHglI9NwgHAkQ+Ju738NzqKKQKQx0-gqw+Q-g9+MgkE-g7YQs+q7y1Qk6GMnUpUCUGGJgDUkLgwCgHkkCM8wC2i9EShCiJr-GfIVR+CdCzBgw0uPuEgDY3WTBcgnOAgtVAmZAJg+otQ2wZgZpUS5ZP6goJQhQ-EVgRgBCoQFgs2mAKQu1gwJ8z2Zg5RdbZ7KRQwOAyIOKNWHa1SB0preubGFQJA5+jWft9+2l6F+W0hdAve9ayEagXiegQoeY1rXQXAu2OEqwpOVzVgV+nVZ+JAKQmu2AMIRoZAy2Eg0oRiM6OAShcgNzpo6QmAMMvG22pTvSYgRo7qhQEA5l2620mA82JAfsKgG9zhN1XAgwXAPgjNINOAWi6QoQ1QpNEbVZMAeYnUCQbQagLwgoxzdAK6WVNmYgp2ZAb6FZ4tZg0keYYgAwWxJxTh+K1QqWLKFgQ+u2tQFhZgbQWuDs8yuUcB6GPcCgRYHq1MmAv+F4-8u1cTXbWgxYJAEAO1oQtQnJwg-gsGZATuNIhQ6AOArgcaoxpyKQzwC8KgVgJAEqkoXQHAm8NId2WgeJXk1QZXAgzuWg9RvYZgZA-glk9I1QRnKQzDg4uBCWcgVg6CREnVJQfePBMA+CVbveApVgFs2pZzWjrAhT3Y7gWYKgSe6AoYoZkQEAeYSgRsRQCQXM0eXAK6qwwkgopwcM-GpwFIhYT4GApXcqmAEu1QuArA2wEgKA9CUoNeUS2U5whQAgCI0sXDdAeg0PHqfetQv9HwdK6CswEAm43m4Cbp6OKQ42HAxbl6Qy8urEOAHAbQ7ooDmZDoBi0AXAKAS4OzSgPJCQ4tEkpw-yOQbEuM-gdAUxgoAgIBKdHAnhyMpnFxAmkQ1P+DCganT01QxTGtgobw5IegJ7auUA8FUAtl2wSA7gVk4t1AULNtEAeaKgHq2+MFQmh6qcyMRhZpKgFgrxQE0of0SoFQr0bTSgzheYRwsYPXMgVgf1DCrUi18JVga6vqxObqk4W1FMUHp94Sg6KGAFMSNC+0eoRgfnuxl8rEQxIFgLnvpS4BiA1U4DICIUDjAFgOAXQB8u4CIAKQzAoQeWtUBuAKB4K6Yf3Kh18DVBUYTcMaMMhcAoBRABPM5mGHfYDQZAKmHEELBpAoA+wITEAtUj1DpNBQ4aODlYGoaAll+sFLgCxUR4bFagukVPO5nSbCBNwGgBkgEEWpEB5sx4VWHG1kRJAmcdMQYIomlKKJvuisWPsYwUbK4oAguZBJVFCCUVUMEccsuL1LarABMmAILAVBRpcBG00oQsAIGeAaQAqtYL7OhmxxslYACOSIAkEEraNeGvBPOqcFdRiBBgYVOUBIDkBaAuAFINkAVVDCzUcAXAbiBIDYJCIGQOTW9IUByByASAzVJ8Jr2lDUBJmAgfwMgRHgL17K3cJACkAXhdAjy7gVgCoCUCCgxS2+UwkqxcAaAKQH6GvFC25bUldiegcMARGoAVANcYgPMGQFuqrAiAy-fIMBC2JaJT+VRI0CgQ-zv4cmFvCkEcHQBcxG0WgWoNUGDqDBqABIIXCPSeEyBCgDuHkgoEXRGBAYpwIgIZDhgbYgShaE3qiFOAcI6AvgSBNtUSpSIhokQQ+HODELlwzIFgCoOAQUB2RVILcO5IEDoCXUrkrA0VpUiQCYALAEgDaG5DzDHgaQZoRdN7TUDVAEGY2CQgojsBcA5A2MN-ByHSBV02g7gBEqwD3JicNA1SVRpriIAQ01OjLJxL4Eny1AOoEANEEfAmQ3D7wvyYsgxjET1cM8fwFFLMnmZ3RMgOAGANaEw61AWwdAGAHQBJCeAUA+1EwCJEiCFAmo9wTIHzAoCZ1B6VgCQOrhfgVBgORAAQNQhbJqcDuegQGBUH7SKROWueVdKAjmLbB0gQEIgBOGm6UpuEi6CMpqnMo8l7c48KCOfXiiRA6AKAEoANHqIqAKQgyVYPDzaqThWkHgI0LUFMihAwydAKADRggIlx8gLsV4rUGbCBUEMHCIgDdXpBqAtAgIGEMICMCz8VyY1IwF0DrhJCBAFIMmIKEMiD9Bg-GPgi-ntK94A4AoCwCrkUoCAUABzDgA1ByCAVvEXBEwIMG0hEBQg+5PdiUDeBdANAj-FAHmCNBGR7q8maUnoBJA3NfgbqGSLUA7qKIhkFCI1FoDICYBVYCQEwHQCw5GhpCCgYJJ0BtxaADCGYcuPkEpRaAtOmQFcqaGKCHwY+KkTCjSAsCpNqAzLZbLQHGyQJbG+sFUEMFsbuZJaXEtsO9HzTG99i7WTIGp1UixtQQSAK0noA4AuATA9ZH3vBzAAKMjGLXfPNaP+waA6AjuRHFrhwAMENA7xb+PPmUlhh8SCgVgGuSajpAtA2wLPoBUUgVA9At6QuNQDyyWI24J5C4Dr32S+AhgFiFILhBcC6E2gzwMPgkF8CME+IUw0-s8ARCrAVAoEaoL3H6pocTwZWP8lWQ9xgBj0eYCbN5lqAJA-RXQSBL6WUIKBzISgAZCkBcA9o-WV2aqQu18AwAjQnLfxvsNcgJANaUAPMBD2eCCJhAUAahq+UGBWAheeqKitKT+raE7eHCNqBhFYD3A-xFIDQLUDzpfFO6-JCQFnAphX10A-gT4d939ELBPMTuEeLVgECVJMgfqDbHYgGzPxA+l+J6MO22Bq04pmZfwAaAjG0YNALuXmnY1xrXhTgRodALljzBxSkygDJQCiiIB6AbaHAN0VGkvCsARGAsGrCYHXzYwVIf8X4F0DECmJQggoMQAIF940FMU1AduieTMCG9tgTQeCpgBcAVB74YgXwOkziZYNu4DuCemLjDJhB5O+seLFNL7insZA1FTGYt1CDwcSMMgK5KgmcB6AFWcMvBqPC4oflagDgTALshQCZwKkHAJQKQIkC0l0AgIXvJEGZAok1CbQBQCqCIAVA6eMEEgJEGdCsA6MPTdXmoAUBdFHoNIEzCgGAmcNfkfrOwjdRSBIAIAwXaoG0AshaArAqwFADaDiYCB9kuULoOkBkDYM+ogodAMIDkC1BBQ7E7DtgRIDH4oAbQcUiUFOAuA8506FABSGTSvFxhbobXDYlajPAqWrABAr6WgiRQkpjkBZCYDfFaBSQYIDdpkBgBhpri0WTrHmCjRC4jyhwkoIFRPysF4iVgOVDdEFCacfAtjBZCCG0aDABwfqBQDRlgZkB9CmFOgG9hQA0hmo+8lACTmxjHQq2LIRdsShSAcA+gVIxmKLFtyD94EEbdOdql4LRZ4cvgGQD6EOD6D85bZDNkAl2CRAFAHJM7vWXXJqQrkqjTMnAUfHp5VggpE7ImlIIHkLeFWOgNqEbAPpBg0VEwH2jMBcAcAyoDQGeBQBnjkhFIfyeXF2CKocgyrCQJjDUA9DBx1WdWum07jd1dYm3dALADmTiEliFRCoMcGXjISK5+UAaJ3l+To8cgyIMQJSV4gwAwc0cXxlExDrGSEoBFWtC7IUBzxkQ1QNgPgxOh2xVgzwFjPiU7o4B58ZAc+igG2xP53AD1PgoUFsBxpFw4hCACkAUBzoVIfyXqRSEJiqwjQUSb0KrUGCRAOMb8WoDGCsn0Ssi9oJOcygNLfAXAC4r6BIFtaKQuSRA0CBACsCXUsJy7YWGAC0Ak8jQTYCQFoGqBIBagvgGmrZljG+IncnQOFF0Dhklh4IXZYumDmNTLAiwHUYQHsiBZxJQg03EoDgEKCjcSAQ+VFG5PabCBfQogI7JPMmKdxBgWsGQNnJBpChnmbIagI2AOgwAgkt6ZuiQMyClsEgPCR6LoWJxc8aodyeNraFchKKKMzcq4hZl8CiJVEfgI5K2QtkmA-IXQFICVlYYlZM0kIiQRE02ZKA7QGQQxuhS8zCiUAHWaIIzPoiEiXAWyRqvHKUDwYl4cgTqt-GCR-ikA18XLHzXlqQ4lAiJXyl0GsC2MvIagWxMeLoqYzQgd9VyVUjt7zYKAu4FwByVHg5ApcVgNQAPUNxmBHWYAXcOgEnnVCHRnUhWjXUmCEZ1K3QIgNZ0YJKtiQXMBDO4CsCMVW2EOLQK8i+K+AisRARRHckSypytOb8O7GjgEDtQcA8S5PCzIEDdlvVADbHOKREo+FkcYtLggqw7htAD0EgP5X5nsqtli6agPQMmBhm+B3ARyGmstC6CuBAwL8lAFShiY9J6aTINoJjBkA15tQEgcwDn0SpKY4lGgBnttFECG57WQmUqPmQEDCBngLmJQukjIDPwoWIBcmL4HhL0RoxCQGTODEZEgVscsdTaLejEDB0IabpcxsErIAvygSfceEPUQgnP5-E-czZpEHJSfDUgw8L8NlAiYLFDKFIVtlABfw-IKgEgCwNOnFzpItpr-WcKwFuIzpK4yuY8YCBcBeKjZRSaUZs2CXOgp1Yqfzk7yWF8t+qqwHwHSHSBAMBAMdIqNqCpTbBQccwMaqcHYBgAm5cgb2RUNWiryJ6ENb4YpAQLIEL47pasOukrlDVCSooDkXo0jpMEEiAgzILY21GLpUG-gIgDKBSQ0Eh4xvKOLUHkwScLigoH2MIHigXUy48+O4FlQEBHRta3sq7FNLRAWB4lmamkElDUALtyUOQeopgEHZAhag5iuJIFH8AR5SEl+NQJzLMA0gNA-5DQEaEoJ+stIvlEgI0zo7hQSAEUTAO4kam8gwlSdfXKnhogJBBgmte8KKnSC5gYA7gKQtRMbzkSueKbGACtXe4MB-IVgQ6NQBuFHEIAXWI4qigcCYKY0FCFQF0HfREAJUfMXJEaCh4yN+kmXF2XNBeVQBU4NyioOahI30gkAByBXEJmmnSdqWFQNyRRjzGq51wrYeGDIWFVDFdhEoVNhNi2Svx6JjuagiojEANROZYiKxhUDQxKBtA3wqUeb3u5HJ3AKgFFJTyFTMkSgpkGKeIUFahIPwZTamLOBKBc8UABpCUjMTaYlA1kUUu9IMAMJKAGGneYLUYB0CFBF2YLWQIZyBBKBbgPyHID-1M4nBKIkBLSBAF6kdpMgeYU-kOBVzUAuADXeCPpzkAEw1A8UxvvzWPBIB9IWgTgGGvEQBMXSu7eOIpTr71ddCWifreuN8BwFsYKgLirUDkDycjkQ6HaM8AqCNpjhOfU4DencqrBgwk4LPFkFOVRSE5ArMAbrnPwqAQeHaNoFZCjYxSgwGWEwFtIgD4dTA8muYlrogymAxS+0lGQdQKyrk2CgrCzAkAbRcQaQoRfBsqSearASgSwWTFNCE46zYyFFeKj1hAkoVG8KZMwDkDMC8xyWnWYzFwCfLg9mhiuMyuwCZJQFR8i1YQFdnhhmQk8MAeuU0RtLd0E0YAFwMID0DHwECL8kCg6yNAJwhohQWoDRHtDLragY1KIFuBvwQklA6EagECDsRcA6AKQOZMyLLBNhOymABqMrz1y8g10ZgYCNqM0EWw1A1Cd0W3J4lyBngl5YQNQEKCClJhbqQXMSCMRnsqWkQYQAq11A0ggE3IcGGJF8D-RYOVgIkSHFm7hD-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-IOwHyBiAVUaAhjPHD-D1o9SCgJvqMIKzRpiMmQ+8rHishmBqgrhzzBoCWhxMhkt+6oGLgVG2gJ1-PaoAmRKgahMg02qJHBmF1byKQ-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";
            querySelector("body").append(fenrirElement);
            MutationObserver observer = new MutationObserver((List<dynamic> mutations, MutationObserver observer){
                print("why hello there, mutations ${mutations}, observer ${observer}");
                print(mutations.first);
                for(dynamic record in mutations) {
                    if(record is MutationRecord) {
                        for(Node node in (record as MutationRecord).removedNodes) {
                            if(node == fenrirElement) {
                                deleted = true;
                                printText(querySelector("body"));
                            }
                        }
                    }
                }
            });
            observer.observe(fenrirElement.parent,childList: true);
        }
    }

    static void gullsGratitude(Element container) {
        GameStats gs = Game.instance.gameStats;
        for(Tombstone t in gs.theDead) {
            if (t.npcName.contains("Ebony")) gullPopup(
                "Ebony: FINALLY, I FEEL DEATH'S COLD EMBRACE ONCE AGAIN!!!!!",
                container);
            if (t.npcName.contains("Sköll")) gullPopup(
                "Sköll Svelger: YOU DID IT, I ALWAYS BELIEVED IN YOU CHAMP!!!!!", container);
            if (t.npcName.contains("Roger")) gullPopup(
                "Roger: FINALLY, THE DEAD ARE BACK TO THEIR PROPER ZONING!!!!!",
                container);
            if (t.npcName.contains("Halja")) gullPopup(
                "Halja: AS I WAS TRYING TO TELL YOU, WE WERE ALWAYS DEAD.NOW WE MAY FINALLY STOP WEARING THESE EMBARASSING SKELETAL FORMS!!!!!",
                container);
            if (t.npcName.contains("Kid")) gullPopup(
                "The Kid: FINALLY I CAN GO BACK TO FARMING ALL THESE GODDAMN ICEBLOCKS IN THE AFTERLIFE!!!!!",
                container);
        }
    }

    static void beChatty(Element container) {
        print("i'm being chatty)");
        chat(container);
        int time = new Random().nextIntRange(1000,10000);
        if(!deleted && onScreen) {
            new Timer(new Duration(milliseconds: time), () =>
                beChatty(container));
        }
    }

    static void chat(Element container) {
      List<String> choices;
      String op = opinion;
      SoundControl.instance.playSoundEffect("bork");
      print("I'm chatting");
      if(op == HAPPY) choices = happyPhrases;
      if(op == NEUTRAL) choices = neutralPhrases;
      if(op == ANGRY) choices = angryPhrases;

      popup(new Random().pickFrom(choices), container, null,0,new Random().nextIntRange(50, 200), new Random().nextIntRange(50, 400));
    }

    static void sayHello(Element container) {
        List<String> choices;
        String op = opinion;
        SoundControl.instance.playSoundEffect("bork");
        if(op == HAPPY) choices = happyHellos;
        if(op == NEUTRAL) choices = neutralHellos;
        if(op == ANGRY) choices = angryHellos;
        popup(new Random().pickFrom(choices), container);
    }

    static Future<void> popup(String text, Element container,[DivElement currentPopup, int tick=0,int x =170, int y=80]) async {
        int maxTicks = 30;
        if(currentPopup != null && tick == 0) {
            currentPopup.remove();
            currentPopup = null;
        }

        if(currentPopup == null) {
            currentPopup = new DivElement()
                ..classes.add("fenrirPopup")
                ..text = text;
            container.append(currentPopup);
        }
        Random rand = new Random();
        rand.nextInt();
        if(rand.nextBool()) {
            currentPopup.style.left = "${x+rand.nextInt(15)}px";
        }else {
            currentPopup.style.left = "${x-rand.nextInt(15)}px";
        }
        if(rand.nextBool()) {
            currentPopup.style.top = "${y+rand.nextInt(15)}px";
        }else {
            currentPopup.style.top = "${y-rand.nextInt(15)}px";
        }
        if(tick == 1) {
            currentPopup.animate([{"opacity": 100},{"opacity": 0}], 6000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 200), () =>
                popup(text, container, currentPopup, tick+1,x,y));
        }else {
            currentPopup.remove();
        }

    }

    static Future<void> gullPopup(String text, Element container,[DivElement currentPopup]) async {

        if(currentPopup == null) {
            currentPopup = new DivElement()
                ..classes.add("gullPopup")..classes.add("void")
                ..text = text;
            container.append(currentPopup);
        }
        Random rand = new Random();
        rand.nextInt();
        new Timer(new Duration(milliseconds: 20000), () =>
            currentPopup.remove());
    }

}