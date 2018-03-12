package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_cpu_access_propertiesContext;

public class Type_cpu_access_propertiesContextExt extends AbstractBaseExt {

	public Type_cpu_access_propertiesContextExt(Type_cpu_access_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_cpu_access_propertiesContext getContext() {
		return (Type_cpu_access_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_cpu_access_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_cpu_access_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_cpu_access_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
