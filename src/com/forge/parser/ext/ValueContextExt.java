package com.forge.parser.ext;

import java.util.HashMap;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ValueContext;

public class ValueContextExt extends AbstractBaseExt {

	public ValueContextExt(ValueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ValueContext getContext() {
		return (ValueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ValueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ValueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public String getName(String name) {
		ValueContext ctx = getContext();
		name = ctx.value_identifier().extendedContext.getFormattedText();
		return name;
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> names) {
		ValueContext ctx = getContext();
		String name = ctx.value_identifier().extendedContext.getFormattedText();
		if (names.contains(name)) {
			throw new IllegalStateException(
					"Duplicate Value with name " + name + " inside " + parentName + " in line " + ctx.start.getLine());
		} else {
			names.add(name);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		ValueContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("value")) {
				propStore.put("value", ctx.value_identifier().extendedContext.getFormattedText());
			}
		}
	}
}
