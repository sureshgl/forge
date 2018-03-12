package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_cpu_accessContext;

public class Type_cpu_accessContextExt extends AbstractBaseExt {

	public Type_cpu_accessContextExt(Type_cpu_accessContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_cpu_accessContext getContext() {
		return (Type_cpu_accessContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_cpu_access());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_cpu_accessContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_cpu_accessContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
