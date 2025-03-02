COPYRIGHT("Nice_try_but_it_cant_be_this_easy")

VIRUSNAME_PREFIX("The_RuleGod..")
VIRUSNAMES("You_read_the_CTF_rules_i_like_that", "Perfect_form_now_we_just_need_whats_inside", "Well_thats_a_start_but_its_not_quite_it_yet", "It_just_needs_a_little_fixing-come_on", "Congrats_You_got_it")
TARGET(0)

FUNCTIONALITY_LEVEL_MIN(FUNC_LEVEL_096_4)

SIGNATURES_DECL_BEGIN
DECLARE_SIGNATURE(flag_format)
SIGNATURES_DECL_END

SIGNATURES_DEF_BEGIN
/*   matches "TRX{" */
DEFINE_SIGNATURE(flag_format, "0:5452587b")
SIGNATURES_DEF_END

#define FLAG_SIZE 44

bool logical_trigger()
{
    return matches(Signatures.flag_format);
}

uint32_t entrypoint(void)
{
    unsigned char buf, correct = 1;
    int32_t size;
    
    foundVirus("You_read_the_CTF_rules_i_like_that");

    size = seek(-1, SEEK_END);
    
    read(&buf, 1);
    if (buf != '}') {
        return 1;
    }

    foundVirus("Perfect_form_now_we_just_need_whats_inside");

    if (size+1 != FLAG_SIZE) {
        return -1;
    }

    foundVirus("Well_thats_a_start_but_its_not_quite_it_yet");


    seek(-19,SEEK_END);
    read(&buf, 1);
    if ((buf & 1) != 1)
            correct = 0;
    seek(-8,SEEK_END);
    read(&buf, 1);
    if (buf < 78)
            correct = 0;
    seek(-34,SEEK_END);
    read(&buf, 1);
    if ((buf | 30) != 63)
            correct = 0;
    seek(-6,SEEK_END);
    read(&buf, 1);
    if ((buf | 2) != 110)
            correct = 0;
    seek(-32,SEEK_END);
    read(&buf, 1);
    if (buf < 53)
            correct = 0;
    seek(-8,SEEK_END);
    read(&buf, 1);
    if ((buf & 45) != 45)
            correct = 0;
    seek(11,SEEK_SET);
    read(&buf, 1);
    if ((buf | 240) != 255)
            correct = 0;
    seek(-24,SEEK_END);
    read(&buf, 1);
    if (buf < 25)
            correct = 0;
    seek(-20,SEEK_END);
    read(&buf, 1);
    if ((buf & 205) != 77)
            correct = 0;
    seek(-24,SEEK_END);
    read(&buf, 1);
    if (buf < 64)
            correct = 0;
    seek(28,SEEK_SET);
    read(&buf, 1);
    if ((buf & 21) != 21)
            correct = 0;
    seek(-11,SEEK_END);
    read(&buf, 1);
    if (buf >= 176)
            correct = 0;
    seek(12,SEEK_SET);
    read(&buf, 1);
    if (buf >= 147)
            correct = 0;
    seek(-10,SEEK_END);
    read(&buf, 1);
    if (buf >= 146)
            correct = 0;
    seek(-16,SEEK_END);
    read(&buf, 1);
    if ((buf & 25) != 17)
            correct = 0;
    seek(-15,SEEK_END);
    read(&buf, 1);
    if (buf >= 229)
            correct = 0;
    seek(-3,SEEK_END);
    read(&buf, 1);
    if ((buf | 57) != 123)
            correct = 0;
    seek(-39,SEEK_END);
    read(&buf, 1);
    if (buf >= 55)
            correct = 0;
    seek(36,SEEK_SET);
    read(&buf, 1);
    if ((buf & 207) != 77)
            correct = 0;
    seek(-19,SEEK_END);
    read(&buf, 1);
    if (buf >= 115)
            correct = 0;
    seek(31,SEEK_SET);
    read(&buf, 1);
    if ((buf & 218) != 80)
            correct = 0;
    seek(39,SEEK_SET);
    read(&buf, 1);
    if ((buf & 127) != 119)
            correct = 0;
    seek(6,SEEK_SET);
    read(&buf, 1);
    if ((buf | 54) != 119)
            correct = 0;
    seek(-39,SEEK_END);
    read(&buf, 1);
    if ((buf | 136) != 184)
            correct = 0;
    seek(-22,SEEK_END);
    read(&buf, 1);
    if ((buf | 158) != 190)
            correct = 0;
    seek(-15,SEEK_END);
    read(&buf, 1);
    if ((buf | 39) != 119)
            correct = 0;
    seek(32,SEEK_SET);
    read(&buf, 1);
    if ((buf & 52) != 48)
            correct = 0;
    seek(-34,SEEK_END);
    read(&buf, 1);
    if ((buf | 178) != 179)
            correct = 0;
    seek(-20,SEEK_END);
    read(&buf, 1);
    if ((buf & 210) != 82)
            correct = 0;
    seek(32,SEEK_SET);
    read(&buf, 1);
    if (buf >= 64)
            correct = 0;
    seek(-14,SEEK_END);
    read(&buf, 1);
    if ((buf & 226) != 32)
            correct = 0;
    seek(-29,SEEK_END);
    read(&buf, 1);
    if ((buf | 66) != 102)
            correct = 0;
    seek(-28,SEEK_END);
    read(&buf, 1);
    if (buf >= 133)
            correct = 0;
    seek(-21,SEEK_END);
    read(&buf, 1);
    if ((buf | 149) != 245)
            correct = 0;
    seek(-11,SEEK_END);
    read(&buf, 1);
    if ((buf & 255) != 110)
            correct = 0;
    seek(5,SEEK_SET);
    read(&buf, 1);
    if ((buf | 87) != 119)
            correct = 0;
    seek(33,SEEK_SET);
    read(&buf, 1);
    if ((buf | 35) != 111)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if ((buf & 106) != 34)
            correct = 0;
    seek(-26,SEEK_END);
    read(&buf, 1);
    if ((buf | 112) != 118)
            correct = 0;
    seek(-24,SEEK_END);
    read(&buf, 1);
    if (buf < 26)
            correct = 0;
    seek(37,SEEK_SET);
    read(&buf, 1);
    if (buf >= 187)
            correct = 0;
    seek(-2,SEEK_END);
    read(&buf, 1);
    if ((buf | 34) != 51)
            correct = 0;
    seek(23,SEEK_SET);
    read(&buf, 1);
    if (buf < 59)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if ((buf | 184) != 255)
            correct = 0;
    seek(35,SEEK_SET);
    read(&buf, 1);
    if ((buf | 13) != 95)
            correct = 0;
    seek(41,SEEK_SET);
    read(&buf, 1);
    if ((buf | 87) != 119)
            correct = 0;
    seek(41,SEEK_SET);
    read(&buf, 1);
    if (buf >= 168)
            correct = 0;
    seek(-14,SEEK_END);
    read(&buf, 1);
    if ((buf | 173) != 189)
            correct = 0;
    seek(6,SEEK_SET);
    read(&buf, 1);
    if ((buf | 252) != 253)
            correct = 0;
    seek(-15,SEEK_END);
    read(&buf, 1);
    if (buf < 27)
            correct = 0;
    seek(-6,SEEK_END);
    read(&buf, 1);
    if ((buf | 66) != 110)
            correct = 0;
    seek(-4,SEEK_END);
    read(&buf, 1);
    if ((buf | 219) != 251)
            correct = 0;
    seek(19,SEEK_SET);
    read(&buf, 1);
    if (buf >= 180)
            correct = 0;
    seek(-29,SEEK_END);
    read(&buf, 1);
    if ((buf & 233) != 96)
            correct = 0;
    seek(37,SEEK_SET);
    read(&buf, 1);
    if ((buf | 121) != 121)
            correct = 0;
    seek(-21,SEEK_END);
    read(&buf, 1);
    if (buf < 94)
            correct = 0;
    seek(35,SEEK_SET);
    read(&buf, 1);
    if ((buf & 141) != 13)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if ((buf & 137) != 9)
            correct = 0;
    seek(6,SEEK_SET);
    read(&buf, 1);
    if ((buf & 133) != 5)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if (buf < 79)
            correct = 0;
    seek(8,SEEK_SET);
    read(&buf, 1);
    if (buf < 9)
            correct = 0;
    seek(-36,SEEK_END);
    read(&buf, 1);
    if ((buf | 23) != 119)
            correct = 0;
    seek(31,SEEK_SET);
    read(&buf, 1);
    if ((buf | 84) != 116)
            correct = 0;
    seek(22,SEEK_SET);
    read(&buf, 1);
    if (buf < 8)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if ((buf & 241) != 81)
            correct = 0;
    seek(29,SEEK_SET);
    read(&buf, 1);
    if (buf < 57)
            correct = 0;
    seek(4,SEEK_SET);
    read(&buf, 1);
    if ((buf | 55) != 127)
            correct = 0;
    seek(-10,SEEK_END);
    read(&buf, 1);
    if ((buf & 99) != 99)
            correct = 0;
    seek(-30,SEEK_END);
    read(&buf, 1);
    if ((buf & 90) != 74)
            correct = 0;
    seek(22,SEEK_SET);
    read(&buf, 1);
    if ((buf & 109) != 32)
            correct = 0;
    seek(22,SEEK_SET);
    read(&buf, 1);
    if ((buf & 74) != 0)
            correct = 0;
    seek(-22,SEEK_END);
    read(&buf, 1);
    if ((buf | 38) != 54)
            correct = 0;
    seek(21,SEEK_SET);
    read(&buf, 1);
    if (buf >= 171)
            correct = 0;
    seek(23,SEEK_SET);
    read(&buf, 1);
    if ((buf | 159) != 255)
            correct = 0;
    seek(7,SEEK_SET);
    read(&buf, 1);
    if (buf < 1)
            correct = 0;
    seek(16,SEEK_SET);
    read(&buf, 1);
    if ((buf & 101) != 69)
            correct = 0;
    seek(40,SEEK_SET);
    read(&buf, 1);
    if ((buf | 185) != 249)
            correct = 0;
    seek(27,SEEK_SET);
    read(&buf, 1);
    if (buf < 18)
            correct = 0;
    seek(-22,SEEK_END);
    read(&buf, 1);
    if ((buf | 60) != 60)
            correct = 0;
    seek(35,SEEK_SET);
    read(&buf, 1);
    if (buf < 10)
            correct = 0;
    seek(29,SEEK_SET);
    read(&buf, 1);
    if (buf >= 249)
            correct = 0;
    seek(-16,SEEK_END);
    read(&buf, 1);
    if ((buf & 93) != 85)
            correct = 0;
    seek(39,SEEK_SET);
    read(&buf, 1);
    if ((buf & 202) != 66)
            correct = 0;
    seek(37,SEEK_SET);
    read(&buf, 1);
    if ((buf & 242) != 96)
            correct = 0;
    seek(26,SEEK_SET);
    read(&buf, 1);
    if (buf >= 178)
            correct = 0;
    seek(-23,SEEK_END);
    read(&buf, 1);
    if ((buf & 171) != 32)
            correct = 0;
    seek(10,SEEK_SET);
    read(&buf, 1);
    if ((buf & 252) != 48)
            correct = 0;
    seek(6,SEEK_SET);
    read(&buf, 1);
    if ((buf | 230) != 247)
            correct = 0;
    seek(-14,SEEK_END);
    read(&buf, 1);
    if ((buf | 92) != 125)
            correct = 0;
    seek(-9,SEEK_END);
    read(&buf, 1);
    if ((buf | 252) != 255)
            correct = 0;
    seek(-23,SEEK_END);
    read(&buf, 1);
    if ((buf & 159) != 16)
            correct = 0;
    seek(12,SEEK_SET);
    read(&buf, 1);
    if ((buf | 248) != 251)
            correct = 0;
    seek(-24,SEEK_END);
    read(&buf, 1);
    if ((buf | 10) != 111)
            correct = 0;
    seek(39,SEEK_SET);
    read(&buf, 1);
    if (buf >= 151)
            correct = 0;
    seek(41,SEEK_SET);
    read(&buf, 1);
    if ((buf | 30) != 126)
            correct = 0;
    seek(-17,SEEK_END);
    read(&buf, 1);
    if (buf < 20)
            correct = 0;
    seek(-19,SEEK_END);
    read(&buf, 1);
    if (buf >= 250)
            correct = 0;
    seek(-29,SEEK_END);
    read(&buf, 1);
    if ((buf | 160) != 228)
            correct = 0;
    seek(-20,SEEK_END);
    read(&buf, 1);
    if ((buf & 13) != 13)
            correct = 0;
    seek(13,SEEK_SET);
    read(&buf, 1);
    if ((buf & 238) != 32)
            correct = 0;
    seek(-26,SEEK_END);
    read(&buf, 1);
    if ((buf & 21) != 4)
            correct = 0;
    seek(31,SEEK_SET);
    read(&buf, 1);
    if (buf >= 192)
            correct = 0;
    seek(40,SEEK_SET);
    read(&buf, 1);
    if ((buf | 191) != 255)
            correct = 0;
    seek(-12,SEEK_END);
    read(&buf, 1);
    if ((buf & 201) != 1)
            correct = 0;
    seek(-26,SEEK_END);
    read(&buf, 1);
    if (buf >= 109)
            correct = 0;
    seek(-4,SEEK_END);
    read(&buf, 1);
    if (buf >= 99)
            correct = 0;
    seek(9,SEEK_SET);
    read(&buf, 1);
    if ((buf & 187) != 50)
            correct = 0;
    seek(40,SEEK_SET);
    read(&buf, 1);
    if ((buf & 191) != 33)
            correct = 0;
    seek(-10,SEEK_END);
    read(&buf, 1);
    if (buf >= 252)
            correct = 0;
    seek(-20,SEEK_END);
    read(&buf, 1);
    if (buf >= 176)
            correct = 0;
    seek(-35,SEEK_END);
    read(&buf, 1);
    if (buf < 92)
            correct = 0;
    seek(-29,SEEK_END);
    read(&buf, 1);
    if (buf >= 187)
            correct = 0;
    seek(-17,SEEK_END);
    read(&buf, 1);
    if ((buf | 242) != 255)
            correct = 0;
    seek(16,SEEK_SET);
    read(&buf, 1);
    if (buf >= 195)
            correct = 0;
    seek(16,SEEK_SET);
    read(&buf, 1);
    if ((buf & 42) != 10)
            correct = 0;
    seek(-34,SEEK_END);
    read(&buf, 1);
    if ((buf | 78) != 127)
            correct = 0;
    seek(23,SEEK_SET);
    read(&buf, 1);
    if (buf < 48)
            correct = 0;
    seek(23,SEEK_SET);
    read(&buf, 1);
    if (buf >= 114)
            correct = 0;
    seek(22,SEEK_SET);
    read(&buf, 1);
    if ((buf | 111) != 127)
            correct = 0;
    seek(-36,SEEK_END);
    read(&buf, 1);
    if (buf >= 218)
            correct = 0;
    seek(24,SEEK_SET);
    read(&buf, 1);
    if ((buf | 225) != 255)
            correct = 0;
    seek(-37,SEEK_END);
    read(&buf, 1);
    if ((buf & 120) != 88)
            correct = 0;
    seek(-8,SEEK_END);
    read(&buf, 1);
    if ((buf | 157) != 253)
            correct = 0;
    seek(-12,SEEK_END);
    read(&buf, 1);
    if (buf < 40)
            correct = 0;
    seek(-36,SEEK_END);
    read(&buf, 1);
    if (buf >= 103)
            correct = 0;
    seek(33,SEEK_SET);
    read(&buf, 1);
    if (buf >= 234)
            correct = 0;
    seek(-33,SEEK_END);
    read(&buf, 1);
    if ((buf & 98) != 66)
            correct = 0;
    seek(-29,SEEK_END);
    read(&buf, 1);
    if (buf >= 108)
            correct = 0;
    seek(-18,SEEK_END);
    read(&buf, 1);
    if ((buf | 241) != 245)
            correct = 0;
    seek(-18,SEEK_END);
    read(&buf, 1);
    if ((buf & 200) != 64)
            correct = 0;
    seek(26,SEEK_SET);
    read(&buf, 1);
    if (buf >= 172)
            correct = 0;
    seek(10,SEEK_SET);
    read(&buf, 1);
    if ((buf & 184) != 48)
            correct = 0;
    seek(9,SEEK_SET);
    read(&buf, 1);
    if (buf < 23)
            correct = 0;
    seek(-37,SEEK_END);
    read(&buf, 1);
    if (buf < 30)
            correct = 0;
    seek(-26,SEEK_END);
    read(&buf, 1);
    if ((buf | 156) != 254)
            correct = 0;
    seek(8,SEEK_SET);
    read(&buf, 1);
    if ((buf & 188) != 32)
            correct = 0;
    seek(-5,SEEK_END);
    read(&buf, 1);
    if (buf >= 254)
            correct = 0;
    seek(-11,SEEK_END);
    read(&buf, 1);
    if (buf < 40)
            correct = 0;
    seek(20,SEEK_SET);
    read(&buf, 1);
    if (buf >= 208)
            correct = 0;
    seek(-22,SEEK_END);
    read(&buf, 1);
    if (buf >= 135)
            correct = 0;
    seek(-9,SEEK_END);
    read(&buf, 1);
    if ((buf | 10) != 95)
            correct = 0;
    seek(-6,SEEK_END);
    read(&buf, 1);
    if ((buf & 160) != 32)
            correct = 0;
    seek(-14,SEEK_END);
    read(&buf, 1);
    if (buf >= 204)
            correct = 0;
    seek(-12,SEEK_END);
    read(&buf, 1);
    if (buf >= 63)
            correct = 0;
    seek(27,SEEK_SET);
    read(&buf, 1);
    if (buf >= 229)
            correct = 0;
    seek(-15,SEEK_END);
    read(&buf, 1);
    if ((buf | 4) != 118)
            correct = 0;
    seek(-3,SEEK_END);
    read(&buf, 1);
    if ((buf & 43) != 34)
            correct = 0;
    seek(11,SEEK_SET);
    read(&buf, 1);
    if (buf >= 116)
            correct = 0;
    seek(-34,SEEK_END);
    read(&buf, 1);
    if ((buf | 93) != 127)
            correct = 0;
    seek(-32,SEEK_END);
    read(&buf, 1);
    if ((buf & 234) != 106)
            correct = 0;
    seek(34,SEEK_SET);
    read(&buf, 1);
    if (buf < 9)
            correct = 0;
    seek(39,SEEK_SET);
    read(&buf, 1);
    if (buf < 36)
            correct = 0;
    seek(15,SEEK_SET);
    read(&buf, 1);
    if ((buf | 191) != 255)
            correct = 0;
    seek(38,SEEK_SET);
    read(&buf, 1);
    if (buf >= 119)
            correct = 0;
    seek(-12,SEEK_END);
    read(&buf, 1);
    if (buf >= 216)
            correct = 0;
    seek(-37,SEEK_END);
    read(&buf, 1);
    if ((buf & 101) != 69)
            correct = 0;
    seek(6,SEEK_SET);
    read(&buf, 1);
    if ((buf | 149) != 245)
            correct = 0;
    seek(25,SEEK_SET);
    read(&buf, 1);
    if ((buf | 142) != 239)
            correct = 0;
    seek(17,SEEK_SET);
    read(&buf, 1);
    if ((buf | 224) != 240)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if (buf >= 220)
            correct = 0;
    seek(17,SEEK_SET);
    read(&buf, 1);
    if ((buf & 128) != 0)
            correct = 0;
    seek(-23,SEEK_END);
    read(&buf, 1);
    if (buf >= 58)
            correct = 0;
    seek(31,SEEK_SET);
    read(&buf, 1);
    if ((buf | 246) != 246)
            correct = 0;
    seek(14,SEEK_SET);
    read(&buf, 1);
    if (buf >= 217)
            correct = 0;
    seek(14,SEEK_SET);
    read(&buf, 1);
    if (buf < 105)
            correct = 0;
    seek(-19,SEEK_END);
    read(&buf, 1);
    if (buf < 63)
            correct = 0;
    seek(-27,SEEK_END);
    read(&buf, 1);
    if ((buf | 207) != 255)
            correct = 0;
    seek(39,SEEK_SET);
    read(&buf, 1);
    if ((buf | 207) != 255)
            correct = 0;
    seek(-32,SEEK_END);
    read(&buf, 1);
    if ((buf & 5) != 1)
            correct = 0;
    seek(9,SEEK_SET);
    read(&buf, 1);
    if (buf >= 218)
            correct = 0;
    seek(38,SEEK_SET);
    read(&buf, 1);
    if ((buf & 191) != 44)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if ((buf | 120) != 123)
            correct = 0;
    seek(21,SEEK_SET);
    read(&buf, 1);
    if ((buf | 188) != 188)
            correct = 0;
    seek(-27,SEEK_END);
    read(&buf, 1);
    if ((buf | 192) != 240)
            correct = 0;
    seek(-35,SEEK_END);
    read(&buf, 1);
    if (buf >= 216)
            correct = 0;
    seek(14,SEEK_SET);
    read(&buf, 1);
    if ((buf | 161) != 239)
            correct = 0;
    seek(-7,SEEK_END);
    read(&buf, 1);
    if ((buf | 48) != 113)
            correct = 0;
    seek(-4,SEEK_END);
    read(&buf, 1);
    if ((buf | 111) != 111)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if ((buf & 30) != 18)
            correct = 0;
    seek(16,SEEK_SET);
    read(&buf, 1);
    if (buf >= 130)
            correct = 0;
    seek(38,SEEK_SET);
    read(&buf, 1);
    if (buf >= 255)
            correct = 0;
    seek(-39,SEEK_END);
    read(&buf, 1);
    if (buf >= 59)
            correct = 0;
    seek(17,SEEK_SET);
    read(&buf, 1);
    if ((buf | 72) != 120)
            correct = 0;
    seek(29,SEEK_SET);
    read(&buf, 1);
    if ((buf | 157) != 255)
            correct = 0;
    seek(18,SEEK_SET);
    read(&buf, 1);
    if ((buf | 101) != 103)
            correct = 0;
    seek(-8,SEEK_END);
    read(&buf, 1);
    if ((buf & 63) != 45)
            correct = 0;
    seek(20,SEEK_SET);
    read(&buf, 1);
    if ((buf & 239) != 103)
            correct = 0;
    seek(-16,SEEK_END);
    read(&buf, 1);
    if ((buf & 159) != 23)
            correct = 0;
    seek(-9,SEEK_END);
    read(&buf, 1);
    if ((buf & 179) != 19)
            correct = 0;
    seek(-10,SEEK_END);
    read(&buf, 1);
    if ((buf & 76) != 68)
            correct = 0;
    seek(14,SEEK_SET);
    read(&buf, 1);
    if (buf >= 248)
            correct = 0;
    seek(14,SEEK_SET);
    read(&buf, 1);
    if (buf >= 233)
            correct = 0;
    seek(41,SEEK_SET);
    read(&buf, 1);
    if ((buf & 112) != 112)
            correct = 0;
    seek(28,SEEK_SET);
    read(&buf, 1);
    if ((buf & 130) != 2)
            correct = 0;
    seek(18,SEEK_SET);
    read(&buf, 1);
    if ((buf & 157) != 4)
            correct = 0;
    seek(-28,SEEK_END);
    read(&buf, 1);
    if ((buf | 113) != 127)
            correct = 0;
    seek(-16,SEEK_END);
    read(&buf, 1);
    if ((buf | 29) != 127)
            correct = 0;
    seek(-38,SEEK_END);
    read(&buf, 1);
    if (buf >= 212)
            correct = 0;
    seek(12,SEEK_SET);
    read(&buf, 1);
    if ((buf | 53) != 127)
            correct = 0;
    seek(23,SEEK_SET);
    read(&buf, 1);
    if ((buf & 6) != 4)
            correct = 0;
    seek(-12,SEEK_END);
    read(&buf, 1);
    if ((buf & 87) != 17)
            correct = 0;
    seek(-17,SEEK_END);
    read(&buf, 1);
    if ((buf & 123) != 91)
            correct = 0;
    seek(-31,SEEK_END);
    read(&buf, 1);
    if ((buf & 60) != 48)
            correct = 0;
    seek(-23,SEEK_END);
    read(&buf, 1);
    if ((buf & 49) != 48)
            correct = 0;
    seek(21,SEEK_SET);
    read(&buf, 1);
    if ((buf | 215) != 247)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if ((buf & 18) != 18)
            correct = 0;
    seek(-33,SEEK_END);
    read(&buf, 1);
    if (buf < 87)
            correct = 0;
    seek(-31,SEEK_END);
    read(&buf, 1);
    if (buf >= 224)
            correct = 0;
    seek(-5,SEEK_END);
    read(&buf, 1);
    if ((buf & 221) != 85)
            correct = 0;
    seek(-39,SEEK_END);
    read(&buf, 1);
    if (buf >= 155)
            correct = 0;
    seek(-36,SEEK_END);
    read(&buf, 1);
    if ((buf & 131) != 1)
            correct = 0;
    seek(-26,SEEK_END);
    read(&buf, 1);
    if ((buf & 203) != 66)
            correct = 0;
    seek(4,SEEK_SET);
    read(&buf, 1);
    if (buf < 97)
            correct = 0;
    seek(36,SEEK_SET);
    read(&buf, 1);
    if ((buf | 111) != 111)
            correct = 0;
    seek(40,SEEK_SET);
    read(&buf, 1);
    if ((buf | 71) != 103)
            correct = 0;
    seek(-7,SEEK_END);
    read(&buf, 1);
    if ((buf & 22) != 0)
            correct = 0;
    seek(-11,SEEK_END);
    read(&buf, 1);
    if ((buf | 82) != 126)
            correct = 0;
    seek(20,SEEK_SET);
    read(&buf, 1);
    if (buf >= 227)
            correct = 0;
    seek(-12,SEEK_END);
    read(&buf, 1);
    if (buf >= 166)
            correct = 0;
    seek(28,SEEK_SET);
    read(&buf, 1);
    if ((buf | 73) != 127)
            correct = 0;
    seek(-7,SEEK_END);
    read(&buf, 1);
    if ((buf & 19) != 1)
            correct = 0;
    seek(-17,SEEK_END);
    read(&buf, 1);
    if ((buf & 179) != 19)
            correct = 0;
    seek(-32,SEEK_END);
    read(&buf, 1);
    if ((buf & 99) != 99)
            correct = 0;
    seek(-35,SEEK_END);
    read(&buf, 1);
    if ((buf | 196) != 246)
            correct = 0;
    seek(-19,SEEK_END);
    read(&buf, 1);
    if ((buf & 162) != 32)
            correct = 0;
    seek(31,SEEK_SET);
    read(&buf, 1);
    if (buf < 48)
            correct = 0;
    seek(-13,SEEK_END);
    read(&buf, 1);
    if (buf >= 123)
            correct = 0;
    seek(36,SEEK_SET);
    read(&buf, 1);
    if (buf < 1)
            correct = 0;
    seek(-40,SEEK_END);
    read(&buf, 1);
    if ((buf | 96) != 121)
            correct = 0;
    seek(-40,SEEK_END);
    read(&buf, 1);
    if ((buf & 225) != 97)
            correct = 0;
    seek(24,SEEK_SET);
    read(&buf, 1);
    if ((buf | 53) != 127)
            correct = 0;
    seek(34,SEEK_SET);
    read(&buf, 1);
    if (buf >= 253)
            correct = 0;
    seek(17,SEEK_SET);
    read(&buf, 1);
    if (buf >= 91)
            correct = 0;
    seek(40,SEEK_SET);
    read(&buf, 1);
    if (buf >= 215)
            correct = 0;
    seek(7,SEEK_SET);
    read(&buf, 1);
    if ((buf | 110) != 127)
            correct = 0;
    seek(25,SEEK_SET);
    read(&buf, 1);
    if ((buf & 73) != 65)
            correct = 0;
    seek(-11,SEEK_END);
    read(&buf, 1);
    if ((buf | 227) != 239)
            correct = 0;
    seek(-37,SEEK_END);
    read(&buf, 1);
    if ((buf & 37) != 5)
            correct = 0;
    seek(-7,SEEK_END);
    read(&buf, 1);
    if ((buf | 102) != 103)
            correct = 0;
    seek(11,SEEK_SET);
    read(&buf, 1);
    if ((buf & 242) != 82)
            correct = 0;
    seek(-6,SEEK_END);
    read(&buf, 1);
    if ((buf & 160) != 32)
            correct = 0;
    seek(-10,SEEK_END);
    read(&buf, 1);
    if ((buf | 180) != 247)
            correct = 0;
    seek(-28,SEEK_END);
    read(&buf, 1);
    if (buf < 54)
            correct = 0;
    seek(8,SEEK_SET);
    read(&buf, 1);
    if ((buf | 83) != 115)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if ((buf | 201) != 251)
            correct = 0;
    seek(13,SEEK_SET);
    read(&buf, 1);
    if ((buf | 26) != 59)
            correct = 0;
    seek(5,SEEK_SET);
    read(&buf, 1);
    if ((buf & 23) != 16)
            correct = 0;
    seek(17,SEEK_SET);
    read(&buf, 1);
    if (buf < 28)
            correct = 0;
    seek(-31,SEEK_END);
    read(&buf, 1);
    if ((buf & 17) != 17)
            correct = 0;
    seek(14,SEEK_SET);
    read(&buf, 1);
    if ((buf & 247) != 102)
            correct = 0;
    seek(-40,SEEK_END);
    read(&buf, 1);
    if ((buf & 232) != 104)
            correct = 0;
    seek(-16,SEEK_END);
    read(&buf, 1);
    if (buf < 12)
            correct = 0;
    seek(-38,SEEK_END);
    read(&buf, 1);
    if ((buf | 197) != 245)
            correct = 0;
    seek(36,SEEK_SET);
    read(&buf, 1);
    if ((buf | 59) != 127)
            correct = 0;
    seek(26,SEEK_SET);
    read(&buf, 1);
    if (buf < 101)
            correct = 0;
    seek(-15,SEEK_END);
    read(&buf, 1);
    if (buf >= 218)
            correct = 0;
    seek(4,SEEK_SET);
    read(&buf, 1);
    if ((buf & 29) != 25)
            correct = 0;
    seek(12,SEEK_SET);
    read(&buf, 1);
    if ((buf & 132) != 0)
            correct = 0;
    seek(11,SEEK_SET);
    read(&buf, 1);
    if ((buf & 249) != 89)
            correct = 0;
    seek(11,SEEK_SET);
    read(&buf, 1);
    if ((buf | 220) != 223)
            correct = 0;
    seek(-37,SEEK_END);
    read(&buf, 1);
    if (buf >= 253)
            correct = 0;
    seek(26,SEEK_SET);
    read(&buf, 1);
    if ((buf & 24) != 16)
            correct = 0;
    seek(10,SEEK_SET);
    read(&buf, 1);
    if ((buf | 58) != 59)
            correct = 0;
    seek(13,SEEK_SET);
    read(&buf, 1);
    if ((buf | 42) != 59)
            correct = 0;
    seek(-13,SEEK_END);
    read(&buf, 1);
    if ((buf & 138) != 0)
            correct = 0;
    seek(-29,SEEK_END);
    read(&buf, 1);
    if ((buf & 163) != 32)
            correct = 0;
    seek(6,SEEK_SET);
    read(&buf, 1);
    if (buf >= 153)
            correct = 0;
    seek(-39,SEEK_END);
    read(&buf, 1);
    if ((buf & 140) != 0)
            correct = 0;
    seek(-9,SEEK_END);
    read(&buf, 1);
    if ((buf | 74) != 95)
            correct = 0;
    seek(23,SEEK_SET);
    read(&buf, 1);
    if ((buf & 235) != 96)
            correct = 0;
    seek(-27,SEEK_END);
    read(&buf, 1);
    if ((buf | 86) != 118)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if (buf >= 244)
            correct = 0;
    seek(-11,SEEK_END);
    read(&buf, 1);
    if ((buf | 21) != 127)
            correct = 0;
    seek(18,SEEK_SET);
    read(&buf, 1);
    if ((buf & 51) != 34)
            correct = 0;
    seek(41,SEEK_SET);
    read(&buf, 1);
    if (buf < 59)
            correct = 0;
    seek(37,SEEK_SET);
    read(&buf, 1);
    if ((buf | 5) != 101)
            correct = 0;
    seek(13,SEEK_SET);
    read(&buf, 1);
    if ((buf | 42) != 59)
            correct = 0;
    seek(-37,SEEK_END);
    read(&buf, 1);
    if ((buf & 239) != 79)
            correct = 0;
    seek(31,SEEK_SET);
    read(&buf, 1);
    if ((buf & 204) != 68)
            correct = 0;
    seek(9,SEEK_SET);
    read(&buf, 1);
    if ((buf & 112) != 112)
            correct = 0;
    seek(-14,SEEK_END);
    read(&buf, 1);
    if ((buf & 185) != 49)
            correct = 0;
    seek(-20,SEEK_END);
    read(&buf, 1);
    if ((buf & 20) != 20)
            correct = 0;
    seek(38,SEEK_SET);
    read(&buf, 1);
    if (buf >= 135)
            correct = 0;
    seek(-24,SEEK_END);
    read(&buf, 1);
    if (buf >= 157)
            correct = 0;
    seek(15,SEEK_SET);
    read(&buf, 1);
    if ((buf & 181) != 36)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if (buf < 70)
            correct = 0;
    seek(5,SEEK_SET);
    read(&buf, 1);
    if (buf >= 154)
            correct = 0;
    seek(-5,SEEK_END);
    read(&buf, 1);
    if ((buf & 57) != 49)
            correct = 0;
    seek(42,SEEK_SET);
    read(&buf, 1);
    if ((buf | 36) != 55)
            correct = 0;
    seek(26,SEEK_SET);
    read(&buf, 1);
    if (buf >= 227)
            correct = 0;
    seek(9,SEEK_SET);
    read(&buf, 1);
    if ((buf | 206) != 254)
            correct = 0;
    seek(-40,SEEK_END);
    read(&buf, 1);
    if (buf >= 181)
            correct = 0;
    seek(-9,SEEK_END);
    read(&buf, 1);
    if ((buf | 92) != 95)
            correct = 0;
    seek(-17,SEEK_END);
    read(&buf, 1);
    if ((buf & 228) != 68)
            correct = 0;
    seek(4,SEEK_SET);
    read(&buf, 1);
    if ((buf & 137) != 9)
            correct = 0;
    seek(-36,SEEK_END);
    read(&buf, 1);
    if (buf >= 244)
            correct = 0;
    seek(34,SEEK_SET);
    read(&buf, 1);
    if (buf >= 237)
            correct = 0;
    seek(27,SEEK_SET);
    read(&buf, 1);
    if ((buf & 179) != 19)
            correct = 0;
    seek(-28,SEEK_END);
    read(&buf, 1);
    if ((buf & 82) != 82)
            correct = 0;
    seek(-3,SEEK_END);
    read(&buf, 1);
    if ((buf | 49) != 115)
            correct = 0;
    seek(30,SEEK_SET);
    read(&buf, 1);
    if (buf < 35)
            correct = 0;
    seek(21,SEEK_SET);
    read(&buf, 1);
    if (buf >= 122)
            correct = 0;
    seek(-33,SEEK_END);
    read(&buf, 1);
    if ((buf & 8) != 8)
            correct = 0;
    seek(-30,SEEK_END);
    read(&buf, 1);
    if ((buf | 244) != 254)
            correct = 0;
    seek(30,SEEK_SET);
    read(&buf, 1);
    if (buf >= 82)
            correct = 0;
    seek(-19,SEEK_END);
    read(&buf, 1);
    if ((buf & 193) != 65)
            correct = 0;
    seek(10,SEEK_SET);
    read(&buf, 1);
    if ((buf & 29) != 17)
            correct = 0;
    seek(26,SEEK_SET);
    read(&buf, 1);
    if (buf >= 210)
            correct = 0;
    seek(13,SEEK_SET);
    read(&buf, 1);
    if (buf >= 110)
            correct = 0;
    seek(24,SEEK_SET);
    read(&buf, 1);
    if ((buf | 170) != 255)
            correct = 0;
    seek(-14,SEEK_END);
    read(&buf, 1);
    if ((buf & 64) != 0)
            correct = 0;
    seek(-25,SEEK_END);
    read(&buf, 1);
    if ((buf | 216) != 223)
            correct = 0;


    foundVirus("It_just_needs_a_little_fixing-come_on");
    if (correct == 0)
        return -1;

    foundVirus("Congrats_You_got_it");
    return 0;
}
