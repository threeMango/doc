# Converter

场景: 数据库用varchar 来存储, 但是在entity中却用实体类来接受, 这样有一层手动转换的过程,不免有些麻烦，这里就自定义转换过程

## List -> string -> List

通用的类

```java
public abstract class AbstractListConverter<T> implements AttributeConverter<List<T>, String>{

    private Class<T> tClass;

    public AbstractListConverter(Class<T> tClass) {
        this.tClass = tClass;
    }

    @Override
    public String convertToDatabaseColumn(List<T> attribute) {
        if (null == attribute || attribute.size() <= 0) {
            return StringUtil.empty;
        }
        JSONArray array = JSONArray.fromObject(attribute);
        return array.toString();

    }

    @Override
    public List<T> convertToEntityAttribute(String dbData) {
        if (null == dbData || dbData.length() <= 0) {
            return new ArrayList<>();
        }
        JSONArray array = JSONArray.fromObject(dbData);
        Collection collection = JSONArray.toCollection(array, tClass);
        return new ArrayList(collection);
    }
}
```

个性化

```java
public class TestConvert
        extends AbstractListConverter<Test> {

    public TemplateColumnInfoDTOListConverter() {
        super(TemplateFieldRuleDTO.class);
    }

}
```

使用

```java
    @Column(name = "column_info_list")
    @Convert(converter = TestConvert.class)
    public List<Test> getColumnInfoList() {
        return columnInfoList;
    }
```

