package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Hint_zerotime_propertiesContext;

public class Hint_zerotime_propertiesContextExt extends AbstractBaseExt {

	public Hint_zerotime_propertiesContextExt(Hint_zerotime_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hint_zerotime_propertiesContext getContext() {
		return (Hint_zerotime_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hint_zerotime_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hint_zerotime_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hint_zerotime_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
